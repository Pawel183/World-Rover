import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/community/all_community.dart';
import 'package:world_rover/widgets/profile/community_profile_list_item.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> communityFollowedUsers = [];
  List<Map<String, dynamic>> allUsers = [];
  List<dynamic> followedUsersUid = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getFollowedUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        followedUsersUid = currentUserDoc.data()?['followed_accounts'] ?? [];
      });
    } catch (e) {
      print("Error fetching followed users: $e");
    }
  }

  Future<void> getAllUsers() async {
    try {
      final data = await FirebaseFirestore.instance.collection('users').get();
      await getFollowedUsers();

      final List<Map<String, dynamic>> followedUsersData = [];
      final List<Map<String, dynamic>> allUsersData = [];

      for (var user in data.docs) {
        if (user.data()['uid'] == FirebaseAuth.instance.currentUser!.uid) {
          continue;
        }
        final userData = user.data();
        final userStats = await getUserStats(userData);

        final userDataWithStats = {
          ...userData,
          'visitedPlacesCount': userStats['visitedPlacesCount'],
          'visitedCountriesCount': userStats['visitedCountriesCount'],
          'visitedCountries': userStats['visitedCountries'],
        };

        if (followedUsersUid.contains(userData['uid'])) {
          followedUsersData.add(userDataWithStats);
        }
        allUsersData.add(userDataWithStats);
      }

      setState(() {
        communityFollowedUsers = followedUsersData;
        allUsers = allUsersData;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching all users: $e");
    }
  }

  Future<Map<String, dynamic>> getUserStats(
      Map<String, dynamic> communityUser) async {
    try {
      var visitedPlacesCount = 0;
      var visitedCountriesCount = 0;

      final userVisitedPlaces = await FirebaseFirestore.instance
          .collection('user_visited_places')
          .doc(communityUser['uid'])
          .get();

      final userVisitedCountries = await FirebaseFirestore.instance
          .collection('user_visited_countries')
          .doc(communityUser['uid'])
          .get();

      visitedPlacesCount = userVisitedPlaces.data()?.length ?? 0;
      visitedCountriesCount =
          userVisitedCountries.data()?['visited_countries']?.length ?? 0;

      return {
        'visitedPlacesCount': visitedPlacesCount,
        'visitedCountriesCount': visitedCountriesCount,
        'visitedCountries': userVisitedCountries.data()?['visited_countries'],
      };
    } catch (e) {
      print("Error: $e");
      return {
        'visitedPlacesCount': 0,
        'visitedCountriesCount': 0,
        'visitedCountries': [],
      };
    }
  }

  Future<void> setCurrentUserFollowedAccounts(String selectedUserId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      List<String> followedAccounts =
          List<String>.from(currentUserDoc.data()?['followed_accounts'] ?? []);

      if (followedAccounts.contains(selectedUserId)) {
        followedAccounts.remove(selectedUserId);
      } else {
        followedAccounts.add(selectedUserId);
      }

      setState(() {
        followedUsersUid = followedAccounts;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'followed_accounts': followedAccounts,
      });

      await getAllUsers();
    } catch (e) {
      print("Error with updating followed users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (communityFollowedUsers.isEmpty) {
      content = const Center(
        child: Text("Community Page - No users available"),
      );
    } else {
      content = ListView.builder(
        itemCount: communityFollowedUsers.length,
        itemBuilder: (context, index) {
          return CommunityProfileListItem(
            communityUser: communityFollowedUsers[index],
            communityFollowedUsersUid: followedUsersUid,
            onSetCurrentUserFollowedAccounts: setCurrentUserFollowedAccounts,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.person_add_sharp),
              iconSize: 32,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllComunityProfilesScreen(
                      allUsers: allUsers,
                      communityFollowedUsersUid: followedUsersUid,
                      onSetCurrentUserFollowedAccounts:
                          setCurrentUserFollowedAccounts,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
