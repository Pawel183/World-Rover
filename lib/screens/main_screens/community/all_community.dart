import 'package:flutter/material.dart';
import 'package:world_rover/widgets/profile/community_profile_list_item.dart';

class AllComunityProfilesScreen extends StatefulWidget {
  const AllComunityProfilesScreen({
    super.key,
    required this.allUsers,
    required this.communityFollowedUsersUid,
    required this.onSetCurrentUserFollowedAccounts,
  });

  final List<Map<String, dynamic>> allUsers;
  final List<dynamic> communityFollowedUsersUid;
  final Function(String) onSetCurrentUserFollowedAccounts;


  @override
  State<AllComunityProfilesScreen> createState() =>
      _AllComunityProfilesScreenState();
}

class _AllComunityProfilesScreenState extends State<AllComunityProfilesScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.allUsers.isEmpty) {
      content = const Center(
        child: Text("Community Page - No users available"),
      );
    } else {
      content = ListView.builder(
        itemCount: widget.allUsers.length,
        itemBuilder: (context, index) {
          return CommunityProfileListItem(
            communityUser: widget.allUsers[index],
            communityFollowedUsersUid: widget.communityFollowedUsersUid,
            onSetCurrentUserFollowedAccounts:
                widget.onSetCurrentUserFollowedAccounts,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: content,
    );
  }
}
