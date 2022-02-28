import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {

  String _previewImageURL;

  void _showPreview(double lat, double lng) {
    final staticMapImageURL = LocationHelper.generateLocationImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageURL = staticMapImageURL;

    });

  }


  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    }
    catch (error) {
      return;
    }
  }

    Future<void> _selectOnMap() async {
      final LatLng selectedLocation = await Navigator.of(context).push(
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => MapScreen(isSelecting: true)));
      if (selectedLocation == null) {
        return;
      }
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: _previewImageURL == null
                ? Text(
                    "No Location chosen.",
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewImageURL,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text("Select on map"),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
