import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/widgets/avatar_image_changer.dart';

final _firebase = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.setUserAvatar,
  });

  final User? user;
  final void Function() setUserAvatar;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _userAvatarUrl = "";

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
        // _userUsername = data['username'];
      });
    } catch (e) {
      print("Error getting document: $e");
    }

    widget.setUserAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  foregroundImage: _userAvatarUrl.isNotEmpty
                      ? NetworkImage(_userAvatarUrl)
                      : null,
                  radius: 64,
                  child: _userAvatarUrl.isEmpty
                      ? const CircularProgressIndicator()
                      : null,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return AvatarImageChanger(
                          userAvatarUrl: _userAvatarUrl,
                          setUserAvatar: setUserAvatar,
                        );
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      "Change your avatar",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ),
          ],
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
