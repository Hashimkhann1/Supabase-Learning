



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_learning/home_view/home_view.dart';
import 'package:superbase_learning/view/auth/sign_in_view/sign_in_view.dart';

class AuthViewModel {

  final _supabaseAuth = Supabase.instance.client;

  // sign in with email and password
  Future<void> signInWithPassword(BuildContext context, String email, password) async {
    try{

      final userData = await _supabaseAuth.auth.signInWithPassword(email: email, password: password);
      
      if(userData.user != null && userData.session != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
      }

    }catch(error){
      print("Error while siging in with password $error");
    }
  }

  // sign up with email and password
  Future<void> signUpWithEmailPassword(BuildContext context, String email, password) async {
    try{

      final userData = await _supabaseAuth.auth.signUp(email: email, password: password);

      if(userData.user != null && userData.session != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
      }

    }catch(error){
      print("Error while siging in with password $error");
    }
  }

  // sign out
  Future<void> signOut(BuildContext context) async {
    try{

      await _supabaseAuth.auth.signOut().then((onValue) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInView()),(value) => false);
      });

    }catch(error) {
      print("error while sign out $error");
    }
  }

}