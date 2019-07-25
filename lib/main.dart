import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

const kGoogleApiKey = "YOUR_API_KEY";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GoogleMapController mapController;
  double lat, lng;
  String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(40.7128, -74.0060), zoom: 10.0),
            ),
            Positioned(
              top: 50.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            displayPrediction();
                          },
                          iconSize: 30.0)),
                  onChanged: (val) {
                    setState(() {
                      address = val;
                    });
                  },
                ),
              ),
            )
          ],
        ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  navigateResult(String address, double lat, double lng) {
    Geolocator().placemarkFromAddress(address).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(lat, lng),
          zoom: 10.0)));
    });
  }

  displayPrediction() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
    );
    if (p != null) {
      var placeId = p.placeId;
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      lat = detail.result.geometry.location.lat;
      lng = detail.result.geometry.location.lng;
//      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      address = p.description;
      String jalan = detail.result.adrAddress;
      print("ini apa: " + jalan);
      navigateResult(address, lat, lng);
    } else {
      print("alamat tidak ditemukan");
    }

  }

}