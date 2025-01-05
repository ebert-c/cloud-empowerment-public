import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationField extends StatefulWidget {
  
  TextEditingController latitudeController;
  TextEditingController longitudeController;

  LocationField({required this.latitudeController, required this.longitudeController});

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {

  get latitudeController => widget.latitudeController;
  get longitudeController => widget.longitudeController;
  Location _location = Location();

  Future<void> _getCurrentLocation() async {
    LocationData locationData = await _location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        latitudeController.text = locationData.latitude.toString();
        longitudeController.text = locationData.longitude.toString();
      });
    } else {
      // handle error case
      print('Unable to get current location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: latitudeController,
                validator: (value) {
                  if(value != null) {
                    return value.isEmpty ? "Please enter a latitude" : null;
                  }
                  return "Please enter a latitude";
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Latitude',
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: TextFormField(
                controller: longitudeController,
                validator: (value) {
                  if(value != null) {
                    return value.isEmpty ? "Please enter a longitude" : null;
                  }
                  return "Please enter a longitude";
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Longitude',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _getCurrentLocation,
          child: Text('Use Current Location'),
        ),
      ],
    );
  }
}
