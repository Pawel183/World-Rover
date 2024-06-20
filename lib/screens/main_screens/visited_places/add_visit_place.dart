import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:world_rover/models/place_location.dart';
import 'package:world_rover/widgets/visited_places/date_picker.dart';
import 'package:world_rover/widgets/visited_places/location_picker.dart';
import 'package:world_rover/widgets/visited_places/photo_picker.dart';
import 'package:world_rover/widgets/visited_places/visited_place_country.dart';

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
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _resetValues();
    super.dispose();
  }

  void _resetValues() {
    setState(() {
      _pickedCountryCode = "";
      _pickedCountryName = "";
      _pickedDate = DateTime.now();
      _textController.text = "";
      _pickedLocation = null;
      _pickedImageFile = null;
    });
  }

  void _savePlace() async {
    if (_pickedCountryCode.isEmpty ||
        _pickedCountryName.isEmpty ||
        _pickedLocation == null ||
        _pickedImageFile == null ||
        _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final uniqueId = '${timestamp}_${user.uid}';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("users_images")
          .child("visited_places_images")
          .child(user.uid)
          .child("$uniqueId.jpg");

      await storageRef.putFile(_pickedImageFile!);

      final imageUrl = await storageRef.getDownloadURL();

      final visitedPlaceData = {
        'location': {
          'latitude': _pickedLocation!.latitude,
          'longitude': _pickedLocation!.longitude,
          'address': _pickedLocation!.address,
        },
        'date': _pickedDate.toIso8601String(),
        'place_name': _textController.text,
        'image_url': imageUrl,
        'user_id': user.uid,
        'timestamp': timestamp,
      };

      await FirebaseFirestore.instance
          .collection('user_visited_places')
          .doc(user.uid)
          .collection(_pickedCountryCode)
          .doc(uniqueId)
          .set(visitedPlaceData);

      _resetValues();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  void _setCountryPicker(String countryCode, String countryName) {
    setState(() {
      _pickedCountryCode = countryCode;
      _pickedCountryName = countryName;
    });
  }

  void _setLocationPicker(PlaceLocation location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  void _setPickedDated(DateTime pickedDate) {
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _setPickedImage(File pickedImage) {
    setState(() {
      _pickedImageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.save),
                ),
                IconButton(
                  onPressed: _resetValues,
                  icon: const Icon(Icons.restore_sharp),
                )
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Country picker
                VisitedPlaceCountryPicker(
                  onPickCountry: _setCountryPicker,
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
                DatePicker(date: _pickedDate, onPickDate: _setPickedDated),
                const SizedBox(height: 20),

                // Location picker
                LocationPicker(
                    location: _pickedLocation,
                    onPickLocation: _setLocationPicker),
                const SizedBox(height: 20),

                // Photo picker
                PhotoPicker(
                    image: _pickedImageFile, onPickImage: _setPickedImage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
