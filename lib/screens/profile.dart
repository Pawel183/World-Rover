import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            print(user);
            print(user!.email);
          },
          child: const Text("Profile"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
