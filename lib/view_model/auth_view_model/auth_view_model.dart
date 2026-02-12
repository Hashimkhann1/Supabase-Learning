import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_learning/home_view/home_view.dart';
import 'package:superbase_learning/view/auth/sign_in_view/sign_in_view.dart';

class AuthViewModel {
  final _supabaseAuth = Supabase.instance.client;

  // sign in with email and password
  Future<void> signInWithPassword(
    BuildContext context,
    WidgetRef ref,
    String email,
    password,
  ) async {
    try {
      ref.read(loadingProvider.notifier).setEmailLoading(true);

      final userData = await _supabaseAuth.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (userData.user != null && userData.session != null) {
        ref.read(loadingProvider.notifier).setEmailLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } catch (error) {
      ref.read(loadingProvider.notifier).setEmailLoading(false);
      print("Error while signing in with password $error");
    }
  }

  // sign up with email and password
  Future<void> signUpWithEmailPassword(
    BuildContext context,
    WidgetRef ref,
    String email,
    password,
  ) async {
    try {
      ref.read(loadingProvider.notifier).setEmailLoading(true);
      final userData = await _supabaseAuth.auth.signUp(
        email: email,
        password: password,
      );

      if (userData.user != null && userData.session != null) {
        ref.read(loadingProvider.notifier).setEmailLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } catch (error) {
      ref.read(loadingProvider.notifier).setEmailLoading(false);
      print("Error while siging in with password $error");
    }
  }

  // SIGN IN WITH GOOGLE
  Future<void> signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      ref.read(loadingProvider.notifier).setGoogleLoading(true);

      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT'],
        clientId: Platform.isIOS
            ? dotenv.env['IOS_CLIENT']
            : dotenv.env['ANDROID_CLIENT'],
      );

      GoogleSignInAccount account = await googleSignIn.authenticate();
      String idToken = account.authentication.idToken ?? '';
      final authorization =
          await account.authorizationClient.authorizationForScopes([
            'email',
            'profile',
          ]) ??
          await account.authorizationClient.authorizeScopes([
            'email',
            'profile',
          ]);

      final userData = await _supabaseAuth.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      if(userData.user != null && userData.session != null) {
        ref.read(loadingProvider.notifier).setGoogleLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } catch (error) {
      ref.read(loadingProvider.notifier).setGoogleLoading(false);
      print("Error while signing in with google $error");
    }
  }

  // sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _supabaseAuth.auth.signOut().then((onValue) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInView()),
          (value) => false,
        );
      });
    } catch (error) {
      print("error while sign out $error");
    }
  }
}

class LoadingState {
  final bool emailLoading;
  final bool googleLoading;

  const LoadingState({
    this.emailLoading = false,
    this.googleLoading = false,
  });

  LoadingState copyWith({
    bool? emailLoading,
    bool? googleLoading,
  }) {
    return LoadingState(
      emailLoading: emailLoading ?? this.emailLoading,
      googleLoading: googleLoading ?? this.googleLoading,
    );
  }
}

class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const LoadingState());

  void setEmailLoading(bool value) {
    state = state.copyWith(emailLoading: value);
  }

  void setGoogleLoading(bool value) {
    state = state.copyWith(googleLoading: value);
  }

  void reset() {
    state = const LoadingState();
  }
}

final loadingProvider =
StateNotifierProvider<LoadingNotifier, LoadingState>(
      (ref) => LoadingNotifier(),
);