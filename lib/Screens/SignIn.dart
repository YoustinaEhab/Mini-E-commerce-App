import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Screens/SignUp.dart';
import 'package:support_ecommerce_project/Constants/NavigationBar.dart';
import '../data_provider/remote/firebasehelper.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final fromkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: Form(
              key: fromkey,
              child: Center(
                child:  Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'LOGIN NOW',
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
                    ElevatedButton(onPressed: () async {
                      if (fromkey.currentState!.validate()){
                        showDialog(context: context, builder: (context){
                          return const Center(child: CircularProgressIndicator());
                        });
                        FireBaseHelper().signin(_emailController.text.toString(),_passwordController.text.toString()).then((value){
                          if(value is User){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return Navigation_Bar();
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
                          //textStyle: const TextStyle(color: Colors.indigo)
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return  SignUp();
                            }));
                          },
                          child: const Text(
                            'Sign up',
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
          )
      ),
    );
  }
}
