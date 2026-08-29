import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  final SupabaseClient supabaseClient;

  LocationService(this.supabaseClient);

  Future<void> updateLocation1x() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) return;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      await supabaseClient
          .from('users')
          .update({
            'latitude': position.latitude,
            'longitude': position.longitude,
          })
          .eq('id', session.user.id);
    } catch (e) {
      // Ignore location fetch errors silently for cold start
    }
  }
}
