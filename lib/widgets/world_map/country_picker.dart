import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({
    super.key,
    required this.getVisitedCountries,
  });

  final void Function() getVisitedCountries;

  @override
  State<StatefulWidget> createState() {
    return _CountryPickerState();
  }
}

class _CountryPickerState extends State<CountryPicker> {
  String _pickedCountryCode = "";
  String _pickedCountryName = "";
  bool _isContainsCountry = false;

  void _setIsContainsCountry() {
    setState(() {
      _isContainsCountry = !_isContainsCountry;
    });
  }

  void _addCountry() async {
    try {
      var visitedCountriesDoc = await FirebaseFirestore.instance
          .collection('user_visited_countries')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (visitedCountriesDoc.exists) {
        List<String>? listOfVisitedCountries =
            visitedCountriesDoc.data()?['visited_countries']?.cast<String>();

        if (listOfVisitedCountries!.contains(_pickedCountryCode)) {
          _setIsContainsCountry();
          return;
        }
        listOfVisitedCountries.add(_pickedCountryCode);
        await FirebaseFirestore.instance
            .collection('user_visited_countries')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'visited_countries': listOfVisitedCountries,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('user_visited_countries')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'visited_countries': [_pickedCountryCode],
        });
      }

      widget.getVisitedCountries();
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      width: double.infinity,
      child: Column(
        children: [
          
          // Country picker
          CountryListPick(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text('Choose country'),
            ),
            theme: CountryTheme(
              isShowFlag: true,
              isShowTitle: true,
              isShowCode: false,
              isDownIcon: true,
              showEnglishName: true,
            ),
            onChanged: (country) {
              setState(() {
                _pickedCountryCode = country!.code!;
                _pickedCountryName = country.name!;
                _isContainsCountry = false;
              });
            },
          ),
          const SizedBox(height: 20),

          // Add button
          _pickedCountryName == ""
              ? Text(
                  "Pick country",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    _addCountry();
                  },
                  label: Text(
                    "Add $_pickedCountryName to your visited countries",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
          const SizedBox(height: 20),

          // Info text if country is added
          _isContainsCountry
              ? Text("$_pickedCountryName is already on your list")
              : Container(),
        ],
      ),
    );
  }
}
