import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/color.dart';
import 'package:todo/screens/homescreen.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/screens/signup.dart';

import 'appwrite/auth_api.dart';
import 'bloc/auth/auth_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthAPI()),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => AuthAPI(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>().status;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/signup': (context) => const SignupScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      home: value == AuthStatus.uninitialized
          ? const Scaffold(
            backgroundColor: background,
            body: Center(child: CircularProgressIndicator(color: primary,)),
      )
          : value == AuthStatus.authenticated
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
