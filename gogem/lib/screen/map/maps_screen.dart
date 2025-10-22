import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../../data/model/destination_model.dart';
import '../../provider/map/map_provider.dart';
import '../../style/theme/gogem_theme.dart';

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
    tilt: 45,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).loadDestinations();
    });
  }

  void _onMapCreated(GoogleMapController controller) {}

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
                  child: dest.linkGambar.startsWith('http')
                      ? Image.network(
                          dest.linkGambar,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
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
                  Text(
                    "${dest.rating}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: _initialCameraPosition,
            markers: mapProvider.markers.map((marker) {
              final dest = mapProvider.destinations.firstWhere(
                (d) => d.nama == marker.markerId.value,
                orElse: () => Destination.empty(),
              );
              return marker.copyWith(
                onTapParam: () => _showDetailDestination(dest),
              );
            }).toSet(),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: false,
          ),

          // ==== HEADER WAVE ====
          ClipPath(
            clipper: HeaderWaveClipper(),
            child: Container(
              height: 160, // naikkan sedikit agar header lebih tinggi
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GogemColors.secondary,
                    Color(0xFF4AB0B7), // bisa gradien sedikit lebih gelap
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // ==== TEXT DI TENGAH ====
                    Center(
                      child: Text(
                        "Peta Destinasi",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: GogemColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    // ==== BUTTON DI KANAN ATAS ====
                    Positioned(
                      top: 12, // naikkan posisi button
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _toggleMapType,
                        backgroundColor: GogemColors.white,
                        foregroundColor: GogemColors.secondary,
                        child: const Icon(Icons.layers),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== HEADER WAVE CLIPPER ====
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
