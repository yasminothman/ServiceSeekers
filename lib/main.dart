import 'package:login_project_test1/homepage.dart';
import 'package:login_project_test1/payment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_project_test1/authentication/pages/authpage.dart';
import 'splash_screen.dart';
import 'package:login_project_test1/authentication/pages/registerpage.dart';
import 'payment.dart';
import 'homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Register the controller here
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
        ],
        child: SplashScreen(), // Set your appropriate home page widget here
      ),
      routes: {
        // Define routes for the pages
        '/auth': (_) => AuthPage(),
        '/register': (_) => RegisterPage(onTap: () => Navigator.pushNamed(_, '/auth')),
        '/payment': (_) => PaymentPage(
          expertName: '', // Pass the required parameters here
          expertPrice: 0.0,
          bookingDate: '',
          bookingTime: '',
          
        ),
      },
      
    );
  }
}
