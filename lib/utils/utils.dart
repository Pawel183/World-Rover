import 'package:flutter_dotenv/flutter_dotenv.dart';

String myApiKey = dotenv.get("GOOGLE_API_KEY");
String locationImage(pickedLocation) {
  if (pickedLocation == null) {
    return "";
  }

  final lat = pickedLocation!.latitude;
  final lng = pickedLocation!.longitude;

  return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:X%7C$lat,$lng&key=$myApiKey';
}
