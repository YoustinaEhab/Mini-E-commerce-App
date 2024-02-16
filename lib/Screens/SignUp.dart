import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Screens/SignIn.dart';
import 'package:support_ecommerce_project/data_provider/remote/firebasehelper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final fromkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: fromkey,
                    child: Center(
                      child:  Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'Sign UP NOW',
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
                            height: 15,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
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
                            width: 300,
                            child: TextFormField(
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
                            width: 300,
                            child: TextFormField(
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
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              onPressed: () async{
                            if (fromkey.currentState!.validate()){
                              showDialog(context: context, builder: (context){
                                return const Center(child: CircularProgressIndicator());
                              });
                              FireBaseHelper().signup(_emailController.text.toString(),_passwordController.text.toString(),_nameController.text.toString()).then((value){
                                if(value is User){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return  SignIn();
                                  }));
                                }else if(value is String){
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                                }
                              });
                            }
                          },style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  elevation: 12,
                                  fixedSize: const Size(300, 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ) ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return  SignIn();
                                  }));
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          )
      ),
    );;
  }
}
