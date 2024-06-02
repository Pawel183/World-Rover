import 'package:flutter/material.dart';
import 'package:world_rover/screens/profiles/community_profile.dart';

class CommunityProfileListItem extends StatelessWidget {
  const CommunityProfileListItem({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user['image_url'] as String?;
    // final email = user['email'] as String?;
    final username = user['username'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CommunityProfile(
                  user: user,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.all(5),
          leading: CircleAvatar(
            radius: 36,
            foregroundImage: NetworkImage(imageUrl!),
          ),
          title: Text(username!),
          subtitle: const Text("Visited places: X"),
        ),
      ),
    );
  }
}
