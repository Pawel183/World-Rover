import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/community/community_profile.dart';

class CommunityProfileListItem extends StatefulWidget {
  const CommunityProfileListItem({
    super.key,
    required this.communityUser,
    required this.communityFollowedUsersUid,
    required this.onSetCurrentUserFollowedAccounts,
  });

  final Map<String, dynamic> communityUser;
  final List<dynamic> communityFollowedUsersUid;
  final Function(String) onSetCurrentUserFollowedAccounts;

  @override
  State<CommunityProfileListItem> createState() =>
      _CommunityProfileListItemState();
}

class _CommunityProfileListItemState extends State<CommunityProfileListItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.communityUser['image_url'] as String?;
    final username = widget.communityUser['username'] as String?;
    final userUid = widget.communityUser['uid'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommunityProfile(
                        user: widget.communityUser,
                      ),
                    ),
                  );
                },
                contentPadding: const EdgeInsets.all(5),
                leading: CircleAvatar(
                  radius: 42,
                  foregroundImage: NetworkImage(imageUrl!),
                ),
                title: Text(username!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visited places: ${widget.communityUser['visitedPlacesCount']}",
                    ),
                    Text(
                      "Visited countries: ${widget.communityUser['visitedCountriesCount']}",
                    ),
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: widget.communityFollowedUsersUid.contains(userUid)
                        ? const Icon(Icons.star)
                        : const Icon(Icons.star_border),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      setState(() {
                        widget.onSetCurrentUserFollowedAccounts(userUid!);
                      });
                    },
                    iconSize: 32,
                  ),
                ),
              ),
      ),
    );
  }
}
