import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/bottom_navbar/community.dart';
import 'package:world_rover/screens/bottom_navbar/home_page.dart';
import 'package:world_rover/screens/bottom_navbar/visited_places.dart';
import 'package:world_rover/screens/bottom_navbar/world_map.dart';
import 'package:world_rover/screens/profile.dart';

final _firebase = FirebaseAuth.instance;

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  var _userAvatarUrl = "";
  int _selectedIndex = 0;

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
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = [
    HomePageScreen(),
    VisitedPlacesScreen(),
    WorldMapScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: _firebase.currentUser,),
                    
                  ),
                );
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: "Home",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.travel_explore),
            label: "Visited Places",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: "World Map",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: "Community",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
