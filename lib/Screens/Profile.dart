
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});


  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile>{
  final formkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  String name = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future <void> fetchUserData() async {
    // Get the currently logged-in user
    User? user = await FirebaseAuth.instance.currentUser;
    if(user != null){
      // Fetch the user data from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      // Retrieve the user data from the snapshot
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        // Update the state with the retrieved user data
        setState(() {
          name = userData['Name'];
          email = userData['Email'];
          password = userData['Password'];

          // Set the text editing controllers with the user data
          _nameController.text = name;
          _emailController.text = email;
          _passwordController.text = password;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar:  AppBar(
          title:const  Text("Profile",textAlign: TextAlign.center,) ,
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
        ),
        body: Column (
          children: [
            const Align(alignment: Alignment.center,),
            const SizedBox(
              height: 50,
              width: 400,
            ),
            //const  CircleAvatar(backgroundColor: Colors.indigo,radius: 40,),
            const Icon(Icons.person,size: 72,color: Colors.indigo),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: formkey,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          enabled: false,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter Username";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:const BorderSide(style: BorderStyle.solid),

                            ),
                            hintText: "Username",
                            labelText: "Username",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          enabled: false,
                          controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter Email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:const BorderSide(style: BorderStyle.solid),

                    ),
                    hintText: "Email",
                    labelText: "Email",
                  ),

                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  enabled: false,
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter Password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:const BorderSide(style: BorderStyle.solid),
                    ),
                    hintText: "Password",
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      icon: _isPasswordHidden
                          ? const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )
                          : const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
                    ],
                  ),
                ),
            ),
            const SizedBox(
              height: 15,
            ),
            // ElevatedButton(
            //     onPressed: () async{
            //       if(formkey.currentState!.validate()){
            //         User? user = await FirebaseAuth.instance.currentUser;
            //          if (user != null) {
            //         //    try{
            //         //    await user.updateEmail(_emailController.text.toString());
            //         //    await user.updatePassword(_passwordController.text.toString());
            //            // Reauthenticate the user
            //           //  AuthCredential credential = EmailAuthProvider.credential(
            //           //  email: email,
            //           //  password: password,
            //           // );
            //           //   await user.reauthenticateWithCredential(credential);
            //         //FireBaseHelper().deleteUser(email, password, name);
            //         // FireBaseHelper().signup(_emailController.text.toString(), _passwordController.text.toString(), _nameController.text.toString());
            //         FireBaseHelper().updateUser(user.uid, _emailController.text.toString(), _passwordController.text.toString(), _nameController.text.toString());
            //         showDialog(
            //             context: context,
            //             builder: (context) => AlertDialog(
            //           content: const Text('Your profile has been updated successfully!'),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.pop(context),
            //               child: const Text('Ok',style: TextStyle(color: Colors.indigo),),
            //             ),
            //           ],
            //         ),
            //         );
            //        //     }catch(e){
            //        //       print("Exception: $e");
            //        //     }
            //         }
            //       }
            //     },
            //     child: Text("Save",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            //     ),
            // ),
          ]
      ),
      ),
    );
  }
}