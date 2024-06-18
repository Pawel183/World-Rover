import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/bottom_navbar/community.dart';
import 'package:world_rover/screens/bottom_navbar/visited_places.dart';
import 'package:world_rover/screens/bottom_navbar/world_map.dart';
import 'package:world_rover/screens/bottom_navbar/profile.dart';

final _firebase = FirebaseAuth.instance;

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    _widgetOptions = [
      const VisitedPlacesScreen(),
      const WorldMapScreen(),
      const CommunityScreen(),
      ProfileScreen(user: _firebase.currentUser)
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          // Visited Places
          BottomNavigationBarItem(
            icon: const Icon(Icons.travel_explore),
            label: "Visited Places",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),

          // World Map
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: "World Map",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),

          // Community
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: "Community",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),

          // Home Page
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: "Profile",
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
