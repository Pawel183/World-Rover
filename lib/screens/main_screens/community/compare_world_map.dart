import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/widgets/world_map/simple_world_map.dart';

class CompareWorldMapScreen extends StatefulWidget {
  const CompareWorldMapScreen(
      {super.key,
      required this.communityUserVisitedCountries,
      required this.communityUsername});

  final List<dynamic> communityUserVisitedCountries;
  final String communityUsername;

  @override
  State<CompareWorldMapScreen> createState() => _CompareWorldMapScreenState();
}

class _CompareWorldMapScreenState extends State<CompareWorldMapScreen> {
  late List<String> currentUserVisitedCountries = [];

  @override
  void initState() {
    getVisitedCountries();
    super.initState();
  }

  void getVisitedCountries() async {
    final data = await FirebaseFirestore.instance
        .collection('user_visited_countries')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      currentUserVisitedCountries =
          data.data()?['visited_countries']?.cast<String>() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Your visited countries",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 15),
            SimpleWorldMap(
              visitedCountries: currentUserVisitedCountries,
            ),
            const SizedBox(height: 40),
            Text(
              "Visited countries of ${widget.communityUsername}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 15),
            SimpleWorldMap(
              visitedCountries: widget.communityUserVisitedCountries,
            ),
          ],
        ),
      ),
    );
  }
}
