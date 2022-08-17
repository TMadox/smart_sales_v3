import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_sales/Data/Models/location_model.dart';

Future<LocationModel> getLocationData() async {
  try {
    Position pos = await Geolocator.getCurrentPosition();
    final places =
        await placemarkFromCoordinates(pos.latitude, pos.longitude).timeout(
      const Duration(seconds: 10),
    );
    LocationModel locationData = LocationModel(
      locationCode: pos.latitude.toString() + "-" + pos.longitude.toString(),
      locationName: places.first.name ?? "Unkown Location",
    );
    return locationData;
  } catch (e) {
    return LocationModel(
      locationCode: "Unkown Code",
      locationName: "Unkown Name",
    );
  }
}
