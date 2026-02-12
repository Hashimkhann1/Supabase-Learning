

import 'package:flutter/material.dart';
import 'package:superbase_learning/view_model/auth_view_model/auth_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(onPressed: () {
              AuthViewModel().signOut(context);
            }, child: Text("Sign out")),
          )
        ],
      ),
    );
  }
}
