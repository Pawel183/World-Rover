import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/widgets/community_profile_list_item.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  var communityUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void getUsers() async {
    try {
      final allUsers =
          await FirebaseFirestore.instance.collection('users').get();
      final currentUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var user in allUsers.docs) {
        if (user.data()['email'] == currentUser.data()?['email']) {
          continue;
        }

        setState(() {
          communityUsers.add(user.data());
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (communityUsers.isEmpty) {
      return const Center(
        child: Text("Community Page - No users available"),
      );
    }

    return ListView.builder(
      itemCount: communityUsers.length,
      itemBuilder: (context, index) {
        return CommunityProfileListItem(user: communityUsers[index]);
      },
    );
  }
}
