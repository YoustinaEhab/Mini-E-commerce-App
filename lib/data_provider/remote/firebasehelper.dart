import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:support_ecommerce_project/Constants/Products.dart';
import 'package:dio/dio.dart';

class FireBaseHelper {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future <dynamic> signup(String email, String password, String name) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await auth.currentUser!.updateDisplayName(name);
      await auth.currentUser!.reload();
      await saveUser(user.user!.uid, email, password, name);
      if (user.user != null) {
        return user.user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Email is already registered";
      } else if (e.code == "invalid-email") {
        return "Invalid Email";
      } else if (e.code == "weak-password") {
        return "Password is too weak";
      }
    }
  }

  Future <dynamic> signin(String email, String password) async {
    // User? u = auth.currentUser;
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.user != null) {
        return user.user;
      }
      // if(!user.user!.emailVerified){
      //   await u!.sendEmailVerification();
      // }
    } on FirebaseAuthException catch (e) {
      return e.message;
      // if (e.code == "user-not-found") {
      //   return "User not found";
      // } else if (e.code == "invalid-email") {
      //   return "Invalid Email";
      // } else if (e.code == "wrong-password") {
      //   return "Wrong Password";
      // }
    }
  }

  Future<void> signout() async {
    await auth.signOut();
  }

  Future<void> saveUser(String userId, String email, String password, String name) async {
    try {
      await firestore.collection("Users").doc(userId).set({
        "Name": name,
        "Email": email,
        "Password": password,
      });
    } catch (e) {
      print(e);
    }
  }

  String getCurrentUserId() {
    final User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // User is not logged in, handle accordingly
      return '';
    }
  }

  Future<void> addToFavorites(String userId, List<String> favoriteProductIds) async {
    try {
      await firestore.collection("Users").doc(userId).update({
        "Favorites": favoriteProductIds,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromFavorites(String userId, List<String> favoriteProductIds) async {
    try {
      await firestore.collection("Users").doc(userId).update({
        "Favorites": favoriteProductIds,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getFavorites(String userId) async {
    try {
      DocumentSnapshot userDoc = await firestore.collection("Users").doc(userId).get();
      if (userDoc.exists) {
        return List<String>.from(userDoc.get("Favorites") ?? []);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateUser(String userId, String email, String password, String name) async {
    try {
      await firestore.collection("Users").doc(userId).update({
        "Name": name,
        "Email": email,
        "Password": password,
      });
    } catch (e) {
      print(e);
    }
  }
}