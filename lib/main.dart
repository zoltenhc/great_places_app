import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/add_place.dart';
import 'package:great_places_app/screens/places_list.dart';
import 'package:provider/provider.dart';
import 'package:great_places_app/screens/place_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesList(),
        routes: {
          AddPlace.routeName : (ctx) => AddPlace(),
          PlaceDetailScreen.routeName : (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
