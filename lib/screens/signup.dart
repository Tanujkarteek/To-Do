import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/homescreen.dart';
import 'package:todo/screens/login.dart';

import '../appwrite/auth_api.dart';
import '../bloc/auth/auth_bloc.dart';
import '../constants/color.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFirstTime = true;

  clearFields() {
    // Check if the form key and its current state are not null
    if (_formKey.currentState != null) {
      // Clear text fields using controllers
      emailController.clear();
      passwordController.clear();
      nameController.clear();

      // Reset the form state
      _formKey.currentState!.reset();
    } else {
      print('Form key or its current state is null');
    }
  }


  // createAccount() async {
  //   try {
  //     final AuthAPI appwrite = context.read<AuthAPI>();
  //     await appwrite.createUser(
  //       name: nameController.text,
  //       email: emailController.text,
  //       password: passwordController.text,
  //     );
  //     //Navigator.pop(context);
  //     const snackbar = SnackBar(content: Text('Account created!'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  //   } on AppwriteException catch (e) {
  //     //Navigator.pop(context);
  //     showAlert(title: 'Account creation failed', text: e.message.toString());
  //   }
  // }

  showAlert({required String title, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    clearFields();
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, '/signup');
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
        if(state is AuthRegisterSuccess){
          const snackbar = SnackBar(content: Text('Account created!'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
        if(state is AuthRegisterError){
          showAlert(title: 'Account creation failed', text: state.message);
        }
        if(state is AuthRegister){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircularProgressIndicator(),
                      ]),
                );
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
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
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Form(
                      key: _formKey,
                      onChanged: () {
                        if (!isFirstTime) {
                          _formKey.currentState!.validate();
                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.22,
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
                                controller: nameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if(value.length < 3){
                                    return 'Name should be at least 3 characters long';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name',
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    // Signup button
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // All fields are valid, you can perform signup operation
                          // For simplicity, we'll just print the entered data
                          print('Name: ${nameController.text}');
                          print('Email: ${emailController.text}');
                          print('Password: ${passwordController.text}');

                          setState(() {
                            isFirstTime = false;
                          });

                          // You can implement signup logic here
                          // createAccount();
                          context.read<AuthBloc>().add(AuthRegister(
                            name: nameController.text,
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
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already Registered ? ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Log In",
                            style: const TextStyle(
                              color: primary,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Sign Up");
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
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
