// ignore_for_file: camel_case_types, file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String location;
  final LatLng coordinates;

  LocationData(this.location, this.coordinates);
}
