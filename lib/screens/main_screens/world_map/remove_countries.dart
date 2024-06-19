import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/widgets/world_map/remove_country_item.dart';

class RemoveCountries extends StatefulWidget {
  const RemoveCountries({
    super.key,
    required this.visitedCountries,
    required this.getVisitedCountries,
  });

  final List<String> visitedCountries;
  final void Function() getVisitedCountries;

  @override
  State<RemoveCountries> createState() => _RemoveCountriesState();
}

class _RemoveCountriesState extends State<RemoveCountries> {
  void removeCountryFromVisited(String isoCode) async {
    setState(() {
      widget.visitedCountries.remove(isoCode);
      widget.getVisitedCountries();
    });
    await FirebaseFirestore.instance
        .collection('user_visited_countries')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'visited_countries': widget.visitedCountries,
    });
  }

  @override
  Widget build(BuildContext context) {
    var visitedCountriesIso = widget.visitedCountries;
    visitedCountriesIso.sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return RemoveCountryItem(
            isoCode: visitedCountriesIso[index],
            removeCountry: (isoCode) {
              removeCountryFromVisited(isoCode);
            },
          );
        },
        itemCount: visitedCountriesIso.length,
      ),
    );
  }
}
