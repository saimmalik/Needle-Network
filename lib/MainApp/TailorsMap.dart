// ignore_for_file: file_names, unused_element, non_constant_identifier_names, unused_local_variable
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/TailorInfoPage.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:provider/provider.dart';

class TailorsMap extends StatefulWidget {
  const TailorsMap({Key? key}) : super(key: key);

  @override
  State<TailorsMap> createState() => _TailorsMapState();
}

class _TailorsMapState extends State<TailorsMap> {
  Set<Marker> markers = {};
  Position? _currentPosition;
  Future<void> _MyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CurrentLocation),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition CurrentLocation;

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
      CurrentLocation = CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        tilt: 59.440717697143555,
        zoom: 20,
      );
    });
  }

  Future<List<LatLng>> fetchTailerLocations() async {
    List<LatLng> tailerLocations = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Business Info').get();
    for (DocumentSnapshot doc in snapshot.docs) {
      TailorsData tailorsData = TailorsData(
        shopImage: doc['Shop Image'],
        shopName: doc['Shop Name'],
        address: doc['Address'],
        longitude: doc['Longitude'],
        latitude: doc['Latitude'],
        location: doc['Location'],
        phoneNumber: doc['Phone Number'],
        aboutBusiness: doc['About Business'],
        openingTime: doc['Opening Time'],
        closingTime: doc['Closing Time'],
        open24Hours: doc['Open 24 Hours'],
        lahenga: doc['Lahega'],
        sherwani: doc['Sherwani'],
        suits: doc['Suits'],
        waistCoat: doc['WaistCoat'],
        uniforms: doc['Uniforms'],
        pantCoat: doc['Pant Coat'],
        men: doc['Men'],
        women: doc['Women'],
        children: doc['Children'],
        elders: doc['Elders'],
        docId: doc.id,
      );
      double latitude = doc['Latitude'];
      double longitude = doc['Longitude'];
      String shopName = doc['Shop Name'];
      String description = doc['About Business'];
      LatLng location = LatLng(latitude, longitude);
      tailerLocations.add(location);

      markers.add(
        Marker(
          markerId: MarkerId('${location.latitude}${location.longitude}'),
          position: location,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(shopName),
                  content: Text(description),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TailorInfoPage(tailorsData: tailorsData),
                          ),
                        );
                      },
                      child: const Text('Visit'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }

    return tailerLocations;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).loadTailors();
    _getCurrentLocation();
    fetchTailerLocations().then((value) {
      setState(() {});
    });
  }

  List<TailorsData> tailorsData = [];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    tailorsData = Provider.of<DataProvider>(context).tailorsData;
    if (_currentPosition == null) {
      return const Scaffold(
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CurrentLocation,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                    onTap: (pos) {
                      setState(() {
                        markers.removeWhere(
                          (marker) =>
                              marker.markerId ==
                              MarkerId('${pos.latitude}${pos.longitude}'),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 60,
              top: 18,
              child: Text(
                'Find Tailors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 25,
                ),
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
          child: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }
}
