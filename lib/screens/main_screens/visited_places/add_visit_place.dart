import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:world_rover/models/place_location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:world_rover/screens/main_screens/visited_places/map_picker.dart';
import 'package:world_rover/utils/utils.dart';

class AddVisitPlace extends StatefulWidget {
  const AddVisitPlace({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddVisitPlaceState();
  }
}

class _AddVisitPlaceState extends State<AddVisitPlace> {
  String _pickedCountryCode = "";
  String _pickedCountryName = "";
  DateTime _pickedDate = DateTime.now();
  late TextEditingController _textController;
  PlaceLocation? _pickedLocation;
  bool _isPickingLocation = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _pickedLocation = null;
    super.dispose();
  }

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime(2000, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _pickedDate) {
      setState(() {
        _pickedDate = picked;
      });
    }
    print(_pickedDate.toString());
    print(_textController.text);
  }

  Future<void> _savePlace(double lat, double lng) async {
    String myApiKey = dotenv.get("GOOGLE_API_KEY");
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$myApiKey",
    );
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]["formatted_address"];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isPickingLocation = false;
    });

    print(_pickedLocation!.address);
    print(_pickedLocation!.latitude);
    print(_pickedLocation!.longitude);
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

    await _savePlace(lat, lng);
  }

  void _pickLocation() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapPickerScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget containerContent = const Center(
      child: Text('No location picked yet'),
    );

    if (_pickedLocation != null) {
      containerContent = Image.network(
        locationImage(_pickedLocation),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isPickingLocation) {
      containerContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Column(
            children: [
              // Country picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pick a country: ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
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
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Place name
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: (enteredText) {
                    setState(() {
                      _textController.text = enteredText;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    labelText: 'Visit place name',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      _pickDate(context);
                    },
                    label: const Text('Pick a date'),
                    icon: const Icon(Icons.calendar_today),
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Text(
                    _pickedDate.toString().split(' ')[0].replaceAll("-", "/"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Location picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.location_searching),
                        label: const Text('Get current location'),
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(150, 150),
                          alignment: Alignment.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _pickLocation,
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                        width: 1,
                      ),
                    ),
                    child: containerContent,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
