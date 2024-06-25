import 'package:flutter/material.dart';
import 'package:world_rover/widgets/community/country_list_item.dart';

class VisitedCountriesListScreen extends StatelessWidget {
  const VisitedCountriesListScreen({
    super.key,
    required this.visitedCountries,
    required this.username,
  });

  final List<dynamic> visitedCountries;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "$username Visited Countries",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: visitedCountries.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) => CountryListItem(
                isoCode: visitedCountries[index],
              ),
              itemCount: visitedCountries.length,
            )
          : Center(
              child: Text(
                "$username has not visited any country yet.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }
}
