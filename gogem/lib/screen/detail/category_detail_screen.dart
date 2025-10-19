import 'package:flutter/material.dart';
import 'package:gogem/screen/detail/detail_screen.dart';
import '../../data/model/destination_model.dart';
import '../card/destination_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final List<Destination> destinations;

  const CategoryDetailScreen({
    super.key,
    required this.category,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Filter destinasi berdasarkan kategori yang dipilih
    final filteredDestinations = destinations
        .where((dest) => 
            dest.kategori.toLowerCase() == category.toLowerCase()
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: filteredDestinations.isEmpty
          ? Center(
              child: Text(
                'Belum ada destinasi dalam kategori $category.',
                style: TextStyle(color: colorScheme.onBackground.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Menampilkan 2 kolom
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75, // Mengatur rasio agar card tidak terlalu tinggi
              ),
              itemCount: filteredDestinations.length,
              itemBuilder: (context, index) {
                final dest = filteredDestinations[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman DetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(destination: dest),
                      ),
                    );
                  },
                  child: DestinationCard(
                    title: dest.nama,
                    location: dest.kabupatenKota,
                    imagePath: dest.linkGambar,
                    rating: dest.rating,
                    // Karena DestinationCard dibuat untuk ListView horizontal, 
                    // Kita perlu membuat penyesuaian styling jika diperlukan di GridView.
                  ),
                );
              },
            ),
    );
  }
}