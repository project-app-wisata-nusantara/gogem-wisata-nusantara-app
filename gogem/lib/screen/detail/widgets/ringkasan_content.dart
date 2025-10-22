import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/model/destination_model.dart';
import '../../../provider/detail/detail_provider.dart';
import '../../../provider/gemini/gemini_provider.dart';
import '../../../provider/map/map_provider.dart';
import '../../../provider/recommender/recommender_provider.dart';
import '../detail_screen.dart';
import 'detail_transport_icon.dart';
import '../../card/destination_card.dart'; // Ganti import ini

class RingkasanContent extends StatelessWidget {
  final Destination destination;
  static const int _maxLines = 5;

  const RingkasanContent({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFFFF8E1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionSection(),
            const SizedBox(height: 24),
            _buildDistanceSection(),
            const SizedBox(height: 24),
            _buildMapSection(context),
            const SizedBox(height: 24),
            _buildRecommendationSection(context),
          ],
        ),
      ),
    );
  }

  // --- DESKRIPSI
  Widget _buildDescriptionSection() {
    return Consumer<GeminiProvider>(
      builder: (context, geminiProvider, child) {
        final bool hasOriginalDescription =
            destination.deskripsi != null &&
            destination.deskripsi!.trim().isNotEmpty;
        final String displayDescription = hasOriginalDescription
            ? destination.deskripsi!
            : geminiProvider.generatedSummary ?? '';

        if (geminiProvider.isGenerating) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Memuat ringkasan...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (geminiProvider.errorMessage != null) {
          return Center(
            child: Column(
              children: [
                Text(
                  'Gagal memuat ringkasan',
                  style: TextStyle(fontSize: 14, color: Colors.red[700]),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    geminiProvider.generateSummary(
                      destinationName: destination.nama,
                      location: destination.kabupatenKota,
                      category: destination.kategori,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (displayDescription.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada deskripsi tersedia.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          );
        }

        return Consumer<DetailProvider>(
          builder: (context, detailProvider, child) {
            final isExpanded = detailProvider.isExpanded;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayDescription,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  maxLines: isExpanded ? null : _maxLines,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
                if (_needsReadMore(context, displayDescription, isExpanded))
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: detailProvider.toggleExpanded,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isExpanded ? 'Sembunyikan' : 'Selengkapnya',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.orange,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  bool _needsReadMore(BuildContext context, String text, bool isExpanded) {
    if (isExpanded) return true;
    final span = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
    final tp = TextPainter(
      text: span,
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 32);
    return tp.didExceedMaxLines;
  }

  // --- JARAK
  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jarak',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            DetailTransportIcon(icon: Icons.directions_bike, label: '30m'),
            DetailTransportIcon(icon: Icons.directions_car, label: '1j 15m'),
            DetailTransportIcon(icon: Icons.directions_bus, label: '2j'),
            DetailTransportIcon(icon: Icons.train, label: 'N/A'),
            DetailTransportIcon(icon: Icons.flight, label: 'N/A'),
          ],
        ),
      ],
    );
  }

  // --- MAP
  Widget _buildMapSection(BuildContext context) {
    final currentLatLng = LatLng(destination.latitude, destination.longitude);

    Future<void> openMap() async {
      final url =
          'http://maps.google.com/?q=${destination.latitude},${destination.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka peta.')),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi map',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Consumer<MapProvider>(
              builder: (context, mapProvider, _) {
                if (mapProvider.markers.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                return Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentLatLng,
                        zoom: 13,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(destination.nama),
                          position: currentLatLng,
                          infoWindow: InfoWindow(
                            title: destination.nama,
                            snippet: destination.kabupatenKota,
                            onTap: openMap,
                          ),
                        ),
                        ...mapProvider.markers.where(
                          (m) => m.markerId.value != destination.nama,
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton.small(
                        heroTag: 'openMapBtn',
                        backgroundColor: Colors.white,
                        onPressed: openMap,
                        child: const Icon(Icons.map, color: Colors.blue),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- REKOMENDASI
  Widget _buildRecommendationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Wisata Serupa',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Consumer<RecommenderProvider>(
          builder: (context, recommenderProvider, _) {
            final similar = recommenderProvider.getSimilarRecommendations(
              destination,
            );

            if (similar.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Belum ada rekomendasi serupa.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similar.length,
                itemBuilder: (context, index) {
                  final dest = similar[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(destination: dest),
                        ),
                      );
                    },
                    child: DestinationCard(destination: dest),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
