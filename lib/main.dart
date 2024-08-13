// ignore_for_file: duplicate_import

import 'package:cbs_apparels/auth/supplier_login.dart';
import 'package:cbs_apparels/auth/supplier_signup.dart';
import 'package:cbs_apparels/main_screens/supplier_home.dart';
import 'package:cbs_apparels/providers/cart_provider.dart';
import 'package:cbs_apparels/providers/wish_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cbs_apparels/main_screens/welcome_screen.dart';
import 'package:cbs_apparels/auth/customer_signup.dart';
import 'package:cbs_apparels/auth/customer_login.dart';
import 'package:provider/provider.dart';

import 'main_screens/customer_home.dart';
import 'main_screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
      },
    );
  }
}
