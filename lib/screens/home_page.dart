import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var _userAvatarUrl = "";
  var _userUsername = "";

  @override
  void initState() {
    setUserAvatar();
    super.initState();
  }

  void setUserAvatar() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser!.uid)
          .get();
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        _userAvatarUrl = data['image_url'];
        _userUsername = data['username'];
      });
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userUsername),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                print(_userAvatarUrl);
              },
              child: CircleAvatar(
                foregroundImage: _userAvatarUrl.isNotEmpty
                    ? NetworkImage(_userAvatarUrl)
                    : null,
                radius: 20,
                child: _userAvatarUrl.isEmpty
                    ? const CircularProgressIndicator()
                    : null,
              ),
            ),
          ),
        ],
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
