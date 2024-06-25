import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/community/compare_world_map.dart';
import 'package:world_rover/screens/main_screens/community/visited_countries_list.dart';
import 'package:world_rover/widgets/world_map/simple_world_map.dart';

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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          user['username'],
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 10),
        child: Column(
          children: [
            // World Map
            SimpleWorldMap(
              visitedCountries: user['visitedCountries'] ?? [""],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CompareWorldMapScreen(
                      communityUserVisitedCountries:
                          user['visitedCountries'] ?? [""],
                      communityUsername: user['username'],
                    ),
                  ),
                );
              },
              child: const Text("Compare with your visited countries"),
            ),
            const SizedBox(height: 40),

            // Statistic Box
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Places",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${user['visitedPlacesCount']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        const Text(
                          "Countries",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${user['visitedCountriesCount']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Buttons (Visited Places and Visited Countries)
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Coming soon... :)"),
                  ),
                );
              },
              child: const Text("Show Visited Places"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VisitedCountriesListScreen(
                      visitedCountries: user['visitedCountries'] ?? [],
                      username: user['username'],
                    ),
                  ),
                );
              },
              child: const Text("Show Visited Countries"),
            ),
          ],
        ),
      ),
    );
  }
}
