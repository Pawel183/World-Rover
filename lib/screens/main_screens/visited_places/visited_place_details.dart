import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:world_rover/widgets/visited_places/edit_menu_items.dart';

class VisitedPlaceDetailsScreen extends StatelessWidget {
  const VisitedPlaceDetailsScreen({
    super.key,
    required this.visitedPlace,
    required this.onRemovePlace,
  });

  final dynamic visitedPlace;
  final void Function(String timestamp) onRemovePlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          visitedPlace['place_name'],
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          const EditMenuItems(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Navigator.of(context).pop();
                onRemovePlace(visitedPlace['timestamp']);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              visitedPlace['image_url'],
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Column(
                children: [
                  // Place name
                  Text(
                    visitedPlace['place_name'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Address
                  Text(
                    visitedPlace['location']['address'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Date
                  Text(
                    visitedPlace['date'].substring(0, 10),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Navigate to the map screen
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(
                                  visitedPlace['place_name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                iconTheme: const IconThemeData(
                                  color: Colors.white,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              body: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    visitedPlace['location']['latitude'],
                                    visitedPlace['location']['longitude'],
                                  ),
                                  zoom: 15,
                                ),
                                markers: {
                                  Marker(
                                    markerId:
                                        MarkerId(visitedPlace['place_name']),
                                    position: LatLng(
                                      visitedPlace['location']['latitude'],
                                      visitedPlace['location']['longitude'],
                                    ),
                                  ),
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.map_rounded),
                    label: const Text("View on map"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
