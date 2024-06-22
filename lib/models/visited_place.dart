import 'package:location/location.dart';

class VisitedPlace {
  const VisitedPlace({
    required this.date,
    required this.image_url,
    required this.location,
    required this.place_name,    required this.timestamp,
    required this.user_id,
  });

  final String date;
  final String image_url;
  final Location location;
  final String place_name;
  final int timestamp;
  final String user_id;
}
