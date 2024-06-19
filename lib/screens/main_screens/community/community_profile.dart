import 'package:flutter/material.dart';

class CommunityProfile extends StatelessWidget {
  const CommunityProfile({
    super.key,
    required this.user,
  });

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text(user['username']),
      ),
    );
  }
}
