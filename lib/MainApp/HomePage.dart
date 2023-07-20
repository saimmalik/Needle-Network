// ignore_for_file: file_names, unused_local_variable, avoid_print, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needle_network_main/Data_Provider.dart';
import 'package:needle_network_main/MainApp/DrawerPage.dart';
import 'package:needle_network_main/MainApp/LocationSetup.dart';
import 'package:needle_network_main/MainApp/NotificationsPage.dart';
import 'package:needle_network_main/MainApp/TailorInfoPage.dart';
import 'package:needle_network_main/ModalClasses/TailorsData.dart';
import 'package:needle_network_main/ModalClasses/UserData.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class HomePage extends StatefulWidget {
  PersistentTabController? controller;
  HomePage({super.key, this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData? userData;
  List<TailorsData> tailors = [];
  List<TailorsData> filteredTailorsData = [];
  final double radius = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Stream<List<DocumentSnapshot>> stream;
  filterTailorsByRadius() async {
    try {
      final double lat = userData!.latitude!;
      final double lng = userData!.longitude!;

      final geo = GeoFlutterFire();
      final tailorCollectionRef =
          FirebaseFirestore.instance.collection('Business Info');

      Stream<List<DocumentSnapshot>> stream =
          geo.collection(collectionRef: tailorCollectionRef).within(
                center: geo.point(latitude: lat, longitude: lng),
                radius: radius,
                field: 'Location',
                strictMode: true,
              );
      stream.listen((List<DocumentSnapshot> documentList) {
        filteredTailorsData.clear();
        filteredTailorsData = documentList
            .map((DocumentSnapshot snapshot) =>
                TailorsData.fromMap(snapshot.data() as dynamic))
            .toList();
        setState(() {});
        print('Tailors Filtered ${filteredTailorsData.length}');
      });
    } catch (e) {
      print('Failed: $e');
    }
  }

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).loadUserData();
    Provider.of<DataProvider>(context, listen: false).loadTailors();
    filterTailorsByRadius();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    userData = Provider.of<DataProvider>(context).userData;
    tailors = Provider.of<DataProvider>(context).tailorsData;
    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }
    if (filteredTailorsData.isEmpty) {
      filterTailorsByRadius();
      setState(() {});
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: DrawerPage(
        controller: widget.controller,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20),
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 40),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 40),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipOval(
                            child: userData!.profilePic == null
                                ? Image.network(
                                    FirebaseAuth.instance.currentUser!.photoURL
                                        .toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    userData!.profilePic.toString(),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(
                  'Hi ${userData!.name}!',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  'Find the closest',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Text(
                  'tailors in your area',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationSetup(),
                ),
              ).then((value) => {
                    if (value == true)
                      {
                        setState(() {
                          Provider.of<DataProvider>(context, listen: false)
                              .loadUserData();
                          print('done');
                        })
                      }
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Container(
                height: 80,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: ClipOval(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: ColoredBox(
                            color: Colors.red,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 5),
                            child: Text(
                              'Your Location',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: userData!.address == null
                                ? const Text(
                                    'Tap to add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox(
                                    width: 200,
                                    child: Text(
                                      userData!.address.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Tailors',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: tailors.isEmpty
                ? const Center(
                    child: Text(
                      'No nearby tailors found',
                      style: TextStyle(),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<DataProvider>(context, listen: false)
                          .loadTailors();
                      await filterTailorsByRadius();
                      setState(() {
                        print(filteredTailorsData.length);
                        print(tailors.length);
                      });
                    },
                    child: ListView.builder(
                      itemCount: filteredTailorsData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            height: 100,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                filteredTailorsData[index].shopImage.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            filteredTailorsData[index].shopName.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            filteredTailorsData[index].aboutBusiness.toString(),
                            style: const TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TailorInfoPage(
                                  tailorsData: filteredTailorsData[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
