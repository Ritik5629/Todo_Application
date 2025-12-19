import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list_curd/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
    }
    
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text("Todo App",style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.bold),),

      ),
    );
  }
}
