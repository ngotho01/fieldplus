import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationServiceProvider =
Provider<LocationService>((ref) => LocationService());

class LocationService {
  Future<Position?> getCurrentPosition() async {
    // 1. Check if service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    // 2. Check + request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  double? distanceBetween(
      double? jobLat,
      double? jobLon,
      double? curLat,
      double? curLon,
      ) {
    if (jobLat == null || jobLon == null ||
        curLat == null || curLon == null) return null;
    final meters =
    Geolocator.distanceBetween(curLat, curLon, jobLat, jobLon);
    return meters / 1000; // km
  }
}