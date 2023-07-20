// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, file_names, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:provider/provider.dart';

class LocationSetup extends StatefulWidget {
  LocationSetup({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationSetup> createState() => _LocationSetupState();
}

class _LocationSetupState extends State<LocationSetup> {
  Position? _currentPosition;
  LatLng? coordinates;
  Placemark? placemark;
  String? street;
  String? city;
  String? state;
  String? country;
  String? completeAddress;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition CurrentLocation = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    tilt: 59.440717697143555,
    zoom: 20,
  );

  _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 80,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            completeAddress == null
                                ? "Choose your location"
                                : '$completeAddress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.blue;
                                  } else if (states
                                      .contains(MaterialState.disabled)) {
                                    return Colors.grey;
                                  }
                                  return Colors.blue;
                                },
                              ),
                            ),
                            onPressed: () async {
                              if (completeAddress == null) {
                                Fluttertoast.showToast(
                                    msg: 'Please select a location');
                                return;
                              }
                              bool locationSaved =
                                  await Provider.of<DataProvider>(context,
                                          listen: false)
                                      .saveLocation(
                                completeAddress!,
                                coordinates!.latitude,
                                coordinates!.longitude,
                              );
                              if (locationSaved) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: Text(
                              'Set',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CurrentLocation,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: markers,
                onTap: (pos) async {
                  markers.clear();
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      pos.latitude, pos.longitude);
                  coordinates = pos;
                  street = placemarks[0].street ?? "";
                  city = placemarks[0].locality ?? "";
                  state = placemarks[0].administrativeArea ?? "";
                  country = placemarks[0].isoCountryCode ?? "";
                  completeAddress = "$street $city $state $country";

                  markers.add(
                    Marker(
                        markerId: MarkerId('${pos.latitude}${pos.longitude}'),
                        position: LatLng(pos.latitude, pos.longitude),
                        onTap: () {
                          setState(() {
                            markers.removeWhere(
                              (marker) =>
                                  marker.markerId ==
                                  MarkerId('${pos.latitude}${pos.longitude}'),
                            );
                          });
                        }),
                  );
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            _getCurrentLocation();
            _MyLocation();
          },
          child: Icon(Icons.gps_fixed),
        ),
      ),
    );
  }

  Future<void> _MyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CurrentLocation),
    );
  }
}
