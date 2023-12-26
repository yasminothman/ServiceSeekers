import 'package:login_project_test1/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AddressMapScreen extends StatefulWidget {
  @override
  _AddressMapScreenState createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  TextEditingController addressController = TextEditingController();
  GoogleMapController? mapController;
  LatLng? currentLocation;
  String savedAddress = '';

  void showSavedAddressDialog(BuildContext context, String savedAddress) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Saved Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(savedAddress),
            actions: [
              TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          isDarkModeEnabled: false,
                          toggleDarkMode: (bool) {},
                        ), // Replace 'SecondPage()' with the page you want to navigate to
                      ),
                    );
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _searchAddressOnMap() async {
    String address = addressController.text;
    if (address.isNotEmpty) {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location firstResult = locations.first;
        LatLng latLng = LatLng(firstResult.latitude, firstResult.longitude);
        mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        setState(() {
          currentLocation = latLng;
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapSearch(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark firstResult = placemarks.first;
      String address =
          '${firstResult.street}, ${firstResult.locality}, ${firstResult.postalCode}, ${firstResult.country}';
      addressController.text = address;
      setState(() {
        currentLocation = position;
      });
    }
  }

  void _saveAddress() {
    String address = addressController.text;
    setState(() {
      savedAddress = address;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Address Saved'),
          content: Text(savedAddress),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      isDarkModeEnabled: false,
                      toggleDarkMode: (bool) {},
                    ), // Replace 'SecondPage()' with the page you want to navigate to
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Address on Map'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      37.7749, -122.4194), // San Francisco as default location
                  zoom: 12,
                ),
                markers: (currentLocation != null)
                    ? {
                        Marker(
                          markerId: MarkerId('current_location'),
                          position: currentLocation!,
                          onTap: () {
                            _onMapSearch(currentLocation!);
                          },
                        ),
                      }
                    : {},
                onTap: (position) {
                  _onMapSearch(position);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Enter Address',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _searchAddressOnMap,
                    child: Text('Search on Google Maps'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveAddress, // Save the entered address
                    child: Text('Save Address'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Example usage
            TextButton(
              onPressed: () {
                showSavedAddressDialog(context, savedAddress);
              },
              child: Text('Show Saved Address'),
            )
          ],
        ),
      ),
    );
  }
}
