// ignore: file_names
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'component/NavDrawer.dart';
import 'component/genColor.dart';
import 'component/request.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with WidgetsBindingObserver {
  final req = new GenRequest();
  bool isLoaded = false;
  bool loadedMap = false;

  geo.Position currentPosition;
  String _currentAddress = "";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-7.5842909, 110.8162587),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

//  FUNCTION

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GenColor.primaryColor, // status bar color
    ));




    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);

    if (!isLoaded) {
      isLoaded = true;

      _getCurrentLocation();
      _determinePosition();
      getProperty();
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GenColor.primaryColor,
        elevation: 0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, "notifikasi", arguments: );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 26.0,
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: !loadedMap ? Center(child: CircularProgressIndicator(),) : GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To My Position!'),
      //   icon: Icon(Icons.account_circle),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<geo.Position> _determinePosition() async {
    print("search lok");

    bool serviceEnabled;
    geo.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentPosition = await geo.Geolocator.getCurrentPosition();
    print("My Lok $currentPosition");
    _add("me", "My POsition", _currentAddress, currentPosition.latitude, currentPosition.longitude);
    _kGooglePlex = CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 16,
    );
    loadedMap = true;
    return currentPosition;
  }


  _getCurrentLocation() async {

    await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.best)
        .then((geo.Position position) {
      setState(() {
        //Pass the lat and long to the function
        _getAddressFromLatLng(position.latitude, position.longitude);

      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}";
        print(_currentAddress);

      });
    } catch (e) {
      print(e);
    }
  }

  void _add(markerIdVal, nama, keterangan, lat, lng) async {
    final MarkerId markerId = MarkerId(markerIdVal);
    var marker;
    // print("lat "+currentPosition.latitude.toString());
    // creating a new MARKER
    final Uint8List markerIcon = await getBytesFromAsset('asset/logo.png', 100);

    if(markerIdVal == "me"){
      marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: nama, snippet: keterangan),
        onTap: () {
          // _onMarkerTapped(markerId);
        },
      );
    }else{
      marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: nama, snippet: keterangan),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          // _onMarkerTapped(markerId);
        },
      );
    }



    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void getProperty() async {
    var dataProperty = await req.getApi("user/kos");

    if(dataProperty.length != 0) {
      for (int i = 0; i < dataProperty.length; i++) {
        _add(dataProperty[i]["id"].toString(), dataProperty[i]["nama"],
            dataProperty[i]["keterangan"], double.parse(dataProperty[i]["latitude"]),
            double.parse(dataProperty[i]["longtitude"]));
        print("ikan");

      }
    }

    print("DATA $dataProperty");
    print("length" + dataProperty.length.toString());

    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec =
    await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }
}
