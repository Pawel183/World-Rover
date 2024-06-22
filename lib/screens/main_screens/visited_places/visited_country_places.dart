import 'package:flutter/material.dart';

class VisitedCountryPlaces extends StatefulWidget {
  const VisitedCountryPlaces({
    super.key,
    required this.countryName,
    required this.visitedPlaces,
  });

  final String countryName;
  final List<dynamic> visitedPlaces;

  @override
  State<VisitedCountryPlaces> createState() => _VisitedCountryPlacesState();
}

class _VisitedCountryPlacesState extends State<VisitedCountryPlaces> {

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
                  subtitle: Text(place['date'].substring(0, 10)),
                );
              },
            ),
    );
  }
}
