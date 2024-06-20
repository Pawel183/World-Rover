import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:world_rover/models/place_location.dart';
import 'package:world_rover/screens/main_screens/visited_places/map_picker.dart';
import 'package:world_rover/utils/utils.dart';
import 'package:http/http.dart' as http;

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    required this.location,
    required this.onPickLocation,
  });

  final PlaceLocation? location;
  final void Function(PlaceLocation pickedLocation) onPickLocation;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool _isPickingLocation = false;
  PlaceLocation? _pickedLocation;

  Future<String> _getAddress(double lat, double lng) async {
    String myApiKey = dotenv.get("GOOGLE_API_KEY", fallback: '');
    if (myApiKey.isEmpty) {
      throw Exception('Google API key not found');
    }
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$myApiKey",
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch address');
    }

    final resData = json.decode(response.body);
    if (resData['results'].isEmpty) {
      throw Exception('No address found');
    }

    final address = resData['results'][0]["formatted_address"];
    return address;
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isPickingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      setState(() {
        _isPickingLocation = false;
      });
      return;
    }

    final address = await _getAddress(lat, lng);
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isPickingLocation = false;
    });

    widget.onPickLocation(_pickedLocation!);
  }

  void _pickLocation(PlaceLocation? location) async {
    setState(() {
      _isPickingLocation = true;
    });
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => location != null
            ? MapPickerScreen(
                location: location,
              )
            : const MapPickerScreen(),
      ),
    );

    if (pickedLocation == null) {
      setState(() {
        _isPickingLocation = false;
      });
      return;
    }

    final lat = pickedLocation.latitude;
    final lng = pickedLocation.longitude;

    final address = await _getAddress(lat, lng);
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isPickingLocation = false;
    });

    widget.onPickLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget mapContainerContent = const Center(
      child: Text('No location picked yet'),
    );

    if (_pickedLocation != null) {
      mapContainerContent = Image.network(
        locationImage(_pickedLocation!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isPickingLocation) {
      mapContainerContent = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: _isPickingLocation ? null : _getCurrentLocation,
              icon: const Icon(Icons.location_searching),
              label: const Text('Get current location'),
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(150, 150),
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                _isPickingLocation ? null : _pickLocation(widget.location);
              },
              icon: const Icon(Icons.location_pin),
              label: const Text('Pick location'),
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(150, 150),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              width: 1,
            ),
          ),
          child: mapContainerContent,
        ),
      ],
    );
  }
}
