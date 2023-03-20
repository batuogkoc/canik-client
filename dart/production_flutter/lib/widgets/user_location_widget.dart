import 'package:geocoding/geocoding.dart' as geo;

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:mysample/constants/constan_text_styles.dart';

class UserLocationWidget extends StatefulWidget {
  UserLocationWidget({Key? key}) : super(key: key);

  @override
  State<UserLocationWidget> createState() => _UserLocationWidgetState();
}

LocationData? _locationData;
String? _country = '';
Future<void> _getUserLocation() async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Location location = Location();
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
  var placemarks = await geo.placemarkFromCoordinates(_locationData!.latitude!, _locationData!.longitude!);
  _country = placemarks[0].country;
  print(placemarks[0].country);
}

class _UserLocationWidgetState extends State<UserLocationWidget> {
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _country ?? '',
      style: ProjectTextStyles.popUpTextStyle2,
    );
    // return Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           _locationData != null
    //               ? Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(_locationData!.latitude!.toString()),
    //                     Text(_locationData!.longitude!.toString()),
    //                     Text(_locationData!.provider!),
    //                     Text(_country ?? ''),
    //                   ],
    //                 )
    //               : Container(
    //                   height: 100,
    //                   width: 100,
    //                   color: Colors.transparent,
    //                   child: ElevatedButton(
    //                       onPressed: () {
    //                         _getUserLocation();
    //                       },
    //                       child: Text('bas')),
    //                 ),
    //         ],
    //       ),
    //     )
    //     );
  }
}
