import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/screens/main_screens/visited_places/visited_country_places.dart';

class CountryPlaces extends StatelessWidget {
  const CountryPlaces({
    super.key,
    required this.countryCode,
    required this.places,
  });

  final String countryCode;
  final List<dynamic> places;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VisitedCountryPlaces(
                countryName: Country.tryParse(countryCode)?.name ?? countryCode,
                visitedPlaces: places,
              ),
            ),
          );
        },
        focusColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  countryCode,
                  height: 48,
                  width: 62,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Country.tryParse(countryCode) != null
                              ? Country.tryParse(countryCode)!.name
                              : countryCode,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${places.length} places visited',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
