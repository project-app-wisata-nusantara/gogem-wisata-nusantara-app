import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/model/destination_model.dart';

class MapProvider extends ChangeNotifier {
  // ⬅️ tambahkan ini
  final Set<Marker> _markers = {};
  List<Destination> _destinations = [];

  Set<Marker> get markers => _markers;
  List<Destination> get destinations => _destinations;

  Future<void> loadDestinations() async {
    try {
      final response = await rootBundle.loadString('assets/data/dataset.json');
      final data = json.decode(response) as List<dynamic>;
      _destinations = data.map((item) => Destination.fromJson(item)).toList();

      _setMarkers();
      notifyListeners(); // ⬅️ kasih tahu widget agar update UI
    } catch (e) {
      debugPrint("Error loading dataset: $e");
    }
  }

  void _setMarkers() {
    _markers.clear();
    for (var dest in _destinations) {
      _markers.add(
        Marker(
          markerId: MarkerId(dest.nama),
          position: LatLng(dest.latitude, dest.longitude),
          infoWindow: InfoWindow(
            title: dest.nama,
            snippet: "${dest.kategori} • ⭐ ${dest.rating}",
          ),
        ),
      );
    }
    notifyListeners();
  }
}
