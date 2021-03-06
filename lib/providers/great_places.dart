import 'dart:io';
import '../helpers/db_helper.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:great_places_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findByID(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    File image,
      PlaceLocation pickedlocation,
  ) async {
  final address =  await LocationHelper.getPlaceAddress(pickedlocation.latitude, pickedlocation.longitude);
  final updatedLocation = PlaceLocation(latitude: pickedlocation.latitude, longitude: pickedlocation.longitude, address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: updatedLocation,
        image: image);
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(latitude: item['loc_lat'], longitude: item['loc_lng'], address: item['address']),
            ))
        .toList();
    notifyListeners();
  }
}
