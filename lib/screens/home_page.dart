import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _firebase.signOut();
          },
          child: const Text("Sign out"),
        ),
      ),
    );
  }
}
