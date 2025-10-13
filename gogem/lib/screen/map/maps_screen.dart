import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

///import '../../../config/config.dart';
import '../../../data/model/destination_model.dart';
import '../../provider/map/map_provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  MapType _currentMapType = MapType.normal;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-8.483959, 115.2122881),
    zoom: 15,
    tilt: 45, // efek 3D
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).loadDestinations();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    
  }

  void _toggleMapType() {
    setState(() {
      switch (_currentMapType) {
        case MapType.normal:
          _currentMapType = MapType.satellite;
          break;
        case MapType.satellite:
          _currentMapType = MapType.terrain;
          break;
        case MapType.terrain:
          _currentMapType = MapType.hybrid;
          break;
        default:
          _currentMapType = MapType.normal;
      }
    });
  }

  void _showDetailDestination(Destination dest) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    dest.linkGambar,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                dest.nama,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${dest.kategori} • ${dest.kabupatenKota}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text("${dest.rating}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              Text(dest.deskripsi ?? "Tidak ada deskripsi tersedia."),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri url = Uri.parse(dest.linkLokasi);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.map_outlined),
                label: const Text("Lihat di Google Maps"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Destinasi Wisata"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_outlined),
            onPressed: _toggleMapType,
            tooltip: "Ubah tampilan peta",
          ),
        ],
      ),
      body: GoogleMap(
        mapType: _currentMapType,
        initialCameraPosition: _initialCameraPosition,
        markers: mapProvider.markers.map((marker) {
          final dest = mapProvider.destinations.firstWhere(
                  (d) => d.nama == marker.markerId.value,
              orElse: () => Destination.empty());
          return marker.copyWith(
            onTapParam: () => _showDetailDestination(dest),
          );
        }).toSet(),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleMapType,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.layers),
        label: const Text("Tipe Peta"),
      ),
    );
  }
}
