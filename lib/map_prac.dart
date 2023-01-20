// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPrac extends StatefulWidget {
  const MapPrac({Key? key}) : super(key: key);

  @override
  State<MapPrac> createState() => _MapPracState();
}

class _MapPracState extends State<MapPrac> {
  late GoogleMapController mapContoller;

  getCurrentLocation() async {
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

    locationData = await location.getLocation();
    print("Location: $locationData");

    double userLat = double.parse(locationData.latitude.toString());
    double userLong = double.parse(locationData.longitude.toString());
    //  marker add
    addMarker(LatLng(userLat, userLong));
    // camera move
    mapContoller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            userLat,
            userLong,
          ),
          zoom: 17,
        ),
      ),
    );
  }

  Set<Marker> markers = {};
  Set<Circle> circles = {};
  addMarker(LatLng position) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('user'),
          position: position,
          infoWindow: InfoWindow(
            title: "Exd Lahore",
          ),
          zIndex: 90,
        ),
      );
      circles.add(
        Circle(
          circleId: CircleId("12"),
          center: position,
          radius: 100,
          fillColor: Colors.green.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    });
    
  }

MapType mapType  = MapType.normal;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(31.5204, 74.3587),
              zoom: 10,
            ),
            mapType:mapType,
            trafficEnabled: true,
            zoomGesturesEnabled: true,
            markers: markers,
            circles: circles,
            onMapCreated: (controller) {
              mapType = MapType.satellite;
              print("Map Created");
              mapContoller = controller;
              getCurrentLocation();
            },
          ),
          Positioned(
            top: 350,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                mapContoller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(24.8607, 67.0011),
                      zoom: 10,
                    ),
                  ),
                );

                addMarker(LatLng(24.8607, 67.0011));
              },
              child: Text("Karachi"),
            ),
          ),
          Positioned(
            top: 300,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text("Live Location"),
            ),
          ),
        ],
      ),
    );
  }
}
