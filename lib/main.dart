import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Constants/NavigationBar.dart';

import 'Screens/SignIn.dart';
import 'Screens/SignUp.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget start(){
    if(FirebaseAuth.instance.currentUser!=null){
      return Navigation_Bar();
    }else{
      return WelcomeScreen();
    }
}
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support Ecommerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

      ),
      home: start(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(

          child: Column(children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Welcome',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromARGB(255, 123, 131, 174)
              ),
            ),
            const Text(
              'please login or sign up to continue',
              style: TextStyle(
                  color: Color.fromARGB(255, 123, 131, 174)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return  SignIn ();
              }));
            },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    elevation: 12,
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  //textStyle: const TextStyle(color: Colors.indigo)
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ) ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return  SignUp ();
              }));
            },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 123, 131, 174),
                    elevation: 12,
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  //textStyle: const TextStyle(color: Colors.indigo)
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ) ),
          ],),
        )
    );
  }
}
