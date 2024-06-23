import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/widgets/visited_places/country_places.dart';

class SearchPlaceScreen extends SearchDelegate {
  SearchPlaceScreen({
    required this.visitedCountryPlaces,
    required this.countriesCodes,
    required this.getVisitedCountries,
  });

  final Map<String, dynamic> visitedCountryPlaces;
  final List<String> countriesCodes;
  final void Function() getVisitedCountries;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchQuery = query.toLowerCase();
    final filteredCountries = countriesCodes.where((code) {
      final country = Country.tryParse(code)?.name ?? code;
      return country.toLowerCase().contains(searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: filteredCountries.length,
      itemBuilder: (context, index) {
        final countryCode = filteredCountries[index];
        final places = visitedCountryPlaces[countryCode];

        if (places.length == 0) {
          return null;
        }

        return CountryPlaces(
          countryCode: countryCode,
          places: places,
          getVisitedCountries: getVisitedCountries,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchQuery = query.toLowerCase();
    final filteredCountries = countriesCodes.where((code) {
      final country = Country.tryParse(code)?.name ?? code;
      final places = visitedCountryPlaces[code] ?? [];
      if (places.isEmpty) {
        return false;
      }
      return country.toLowerCase().contains(searchQuery);
    }).toList();

    filteredCountries.sort((a, b) {
      final placesA = visitedCountryPlaces[a]?.length ?? 0;
      final placesB = visitedCountryPlaces[b]?.length ?? 0;
      return placesB.compareTo(placesA);
    });

    if (filteredCountries.isEmpty) {
      return Center(
        child: Text('No results found for "$query"'),
      );
    }

    return ListView.builder(
      itemCount: filteredCountries.length,
      itemBuilder: (context, index) {
        final countryCode = filteredCountries[index];
        final country = Country.tryParse(countryCode)?.name ?? countryCode;
        return ListTile(
          title: Text(country),
          onTap: () {
            query = country;
            showResults(context);
          },
        );
      },
    );
  }
}
