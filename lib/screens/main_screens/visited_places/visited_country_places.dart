import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/visited_places/visited_place_details.dart';

class VisitedCountryPlacesScreen extends StatefulWidget {
  const VisitedCountryPlacesScreen({
    super.key,
    required this.countryName,
    required this.countryCode,
    required this.visitedPlaces,
    required this.getVisitedCountries,
  });

  final String countryName;
  final String countryCode;
  final List<dynamic> visitedPlaces;
  final void Function() getVisitedCountries;

  @override
  State<VisitedCountryPlacesScreen> createState() =>
      _VisitedCountryPlacesScreenState();
}

class _VisitedCountryPlacesScreenState
    extends State<VisitedCountryPlacesScreen> {
  void removeVisitedPlace(String timestamp) async {
    setState(() {
      widget.visitedPlaces
          .removeWhere((place) => place['timestamp'] == timestamp);
    });
    widget.getVisitedCountries();

    if (widget.visitedPlaces.isEmpty) {
      Navigator.of(context).pop();
    }

    await FirebaseFirestore.instance
        .collection('user_visited_places')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      widget.countryCode: widget.visitedPlaces,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Visited places in ${widget.countryName}",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: widget.visitedPlaces.isEmpty
          ? Center(
              child: Text("No places visited in ${widget.countryName}"),
            )
          : ListView.builder(
              itemCount: widget.visitedPlaces.length,
              itemBuilder: (context, index) {
                final place = widget.visitedPlaces[index];
                return ListTile(
                  leading: Image.network(
                    place['image_url'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(place['place_name']),
                  subtitle: Text(
                    place['date'].substring(0, 10),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.double_arrow_sharp,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VisitedPlaceDetailsScreen(
                            visitedPlace: place,
                            onRemovePlace: removeVisitedPlace,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
