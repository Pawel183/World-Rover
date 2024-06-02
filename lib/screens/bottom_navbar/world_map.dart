import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:world_rover/widgets/country_picker.dart';
import 'package:world_rover/widgets/simple_world_map.dart';

class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  late List<String> visitedCountries = [""];

  @override
  void initState() {
    getVisitedCountries();
    super.initState();
  }

  void getVisitedCountries() async {
    var visitedCountriesDoc = await FirebaseFirestore.instance
        .collection('user_visited_countries')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      visitedCountries =
          visitedCountriesDoc.data()?['visited_countries']?.cast<String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    var visitedCountriesLength = visitedCountries.length;
    if (visitedCountries.contains("")) {
      visitedCountriesLength = 0;
    }
    var percentOfVisitedWorld =
        double.parse((visitedCountriesLength / 195).toStringAsFixed(3));

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 40, bottom: 10),
      child: Column(
        children: [
          // World Map
          SimpleWorldMap(visitedCountries: visitedCountries),
          const SizedBox(height: 40),

          // Statistic Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  // Headline
                  Text(
                    "Statistic",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Statistic Info (Circular Percent Indicator and Countries Visited Text)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 15,
                        percent: percentOfVisitedWorld,
                        progressColor: Theme.of(context).colorScheme.primary,
                        center: Text(
                          "${(percentOfVisitedWorld * 100).toString()}%",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            visitedCountriesLength.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            "Countries",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),

          // Add/Remove buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add Button
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return CountryPicker(
                        getVisitedCountries: getVisitedCountries,
                      );
                    },
                  );
                },
                label: const Text("Add country"),
                icon: const Icon(Icons.add),
              ),

              // Remove Button
              ElevatedButton.icon(
                label: const Text("Remove country"),
                icon: const Icon(Icons.remove),
                onPressed: () {
                  print(visitedCountries);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
