import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signin_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'package:flutter_application_1/pages/currency_converter_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://svtwdbuururvtbnsgmnf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN2dHdkYnV1cnVydnRibnNnbW5mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNjAwMzIsImV4cCI6MjA3MTkzNjAzMn0.SPPwlL0wRhSho57n74VA3DaTxGw8QlGlt8RGRA7ebXg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => SignupPage(),
        '/converter': (context) => const CurrencyConverterPage(),
        '/profile': (context) => ProfilePage(),
        //'/notes': (context) => const NotePage(),
      },
    );
  }
}
