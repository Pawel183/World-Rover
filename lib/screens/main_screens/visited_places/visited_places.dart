import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/visited_places/add_visit_place.dart';
import 'package:world_rover/widgets/visited_places/country_places.dart';

class VisitedPlacesScreen extends StatefulWidget {
  const VisitedPlacesScreen({super.key});

  @override
  State<VisitedPlacesScreen> createState() => _VisitedPlacesScreenState();
}

class _VisitedPlacesScreenState extends State<VisitedPlacesScreen> {
  late Map<String, dynamic> visitedCountryPlaces = {};
  late List<String> countriesCodes = [];
  late int visitedPlacesCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    getVisitedCountriesPlaces();
    super.initState();
  }

  void getVisitedCountriesPlaces() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> visitedCountriesPlacesDoc =
          await FirebaseFirestore.instance
              .collection('user_visited_places')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      final data = visitedCountriesPlacesDoc.data();

      if (data != null) {
        countriesCodes = data.keys.toList();
        visitedCountryPlaces = data;

        var count = 0;
        for (var code in countriesCodes) {
          List<dynamic> places = visitedCountryPlaces[code];
          count += places.length;
        }

        countriesCodes.sort((a, b) {
          final countryA = Country.tryParse(a)?.name ?? a;
          final countryB = Country.tryParse(b)?.name ?? b;
          return countryA.compareTo(countryB);
        });

        setState(() {
          visitedPlacesCount = count;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistic and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Visited Places",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${visitedPlacesCount.toString()} places",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AddVisitPlace(
                                onAddPlace: getVisitedCountriesPlaces,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Icon(
                        Icons.post_add_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // Visited countries places
                Expanded(
                  child: countriesCodes.isEmpty
                      ? Center(
                          child: Text(
                            "No places visited yet",
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: countriesCodes.length,
                          itemBuilder: (context, index) {
                            final countryCode = countriesCodes[index];
                            final places = visitedCountryPlaces[countryCode];

                            return CountryPlaces(
                              countryCode: countryCode,
                              places: places,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
