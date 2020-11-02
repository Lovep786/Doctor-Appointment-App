import 'package:flutter/material.dart';
import 'Auth/Signin.dart';
import 'Auth/Signup.dart';
import 'HomePage.dart';


void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SigninPage(),
      routes: <String,WidgetBuilder>{
        "/Signin":(BuildContext context)=>SigninPage(),
        "/Signup":(BuildContext context)=>SignupPage()
      },
      
    );
  }
}