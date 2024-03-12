import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/appwrite/database_api.dart';
import 'package:todo/constants/color.dart';

import '../appwrite/auth_api.dart';
import '../bloc/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFirstTime = true;

  clearFields() {
    if (_formKey.currentState != null) {
      // Clear text fields using controllers
      emailController.clear();
      passwordController.clear();

      // Reset the form state
      _formKey.currentState!.reset();
    } else {
      print('Form key or its current state is null');
    }
  }

  // signIn() async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           backgroundColor: Colors.transparent,
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: const [
  //                 CircularProgressIndicator(),
  //               ]),
  //         );
  //       });
  //
  //   try {
  //     final AuthAPI appwrite = context.read<AuthAPI>();
  //     await appwrite.createEmailSession(
  //       email: emailController.text,
  //       password: passwordController.text,
  //     );
  //     Navigator.pop(context);
  //   } on AppwriteException catch (e) {
  //     Navigator.pop(context);
  //     showAlert(title: 'Login failed', text: e.message.toString());
  //   }
  // }

  showAlerts({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //final AuthBloc authBloc = AuthBloc(AuthAPI());
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
        if (state is AuthError) {
          clearFields();
          showAlerts(title: 'Error', text: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child:SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.2,
                    ),
                    const Text(
                      "Tasks",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 88,
                        fontFamily: 'Galorine',
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.1,
                    ),
                    Form(
                      key: _formKey,
                      onChanged: () {
                        if (!isFirstTime) {
                          _formKey.currentState!.validate();
                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.14,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  if(!value.contains('@') || !value.contains('.') || value.length < 5) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.only(left: 20),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if(value.length < 8){
                                    return 'Password should be at least 8 characters long';
                                  }
                                  if(!value.contains(RegExp(r'[A-Z]'))){
                                    return 'Password should contain at least 1 uppercase letter';
                                  }
                                  if(!value.contains(RegExp(r'[a-z]'))){
                                    return 'Password should contain at least 1 lowercase letter';
                                  }
                                  if(!value.contains(RegExp(r'[0-9]'))){
                                    return 'Password should contain at least 1 number';
                                  }
                                  if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
                                    return 'Password should contain at least 1 special character';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.only(left: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),
                    // Login button
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // All fields are valid, you can perform signup operation
                          // For simplicity, we'll just print the entered data
                          print('Email: ${emailController.text}');
                          print('Password: ${passwordController.text}');

                          // You can implement signup logic here
                          setState(() {
                            isFirstTime = false;
                          });
                          context.read<AuthBloc>().add(AuthLogin(
                            email: emailController.text,
                            password: passwordController.text,
                          ));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: background,
                            fontSize: 26,
                            fontFamily: 'WatchQuinn',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),
                    // keep a text asking if not registered then sign up and make signup text clickable
                    RichText(
                      text: TextSpan(
                        text: "Not Registered? ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(
                              color: primary,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              print("Sign Up");
                                Navigator.pushNamedAndRemoveUntil(context, '/signup', (route) => false);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
