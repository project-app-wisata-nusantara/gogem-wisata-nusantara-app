import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/wisata_provider.dart';

class PopularPlacesSection extends StatelessWidget {
  const PopularPlacesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WisataProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Populer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lainnya..'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal scrollable list
        SizedBox(
          height: 260, // Sesuai dengan desain asli
          child: provider.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.popularPlaces.length,
              itemBuilder: (context, index) {
                final place = provider.popularPlaces[index];
                return _buildPlaceCard(place, provider);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(dynamic place, WisataProvider provider) {
    return Consumer<WisataProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => provider.navigateToDetail(context, place),
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section - fixed height
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: place.linkGambar.isNotEmpty && place.linkGambar != "No Image Available"
                          ? Image.network(
                              place.linkGambar,
                              height: 110,
                              width: 160,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 110,
                                  width: 160,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image),
                                );
                              },
                            )
                          : Container(
                              height: 110,
                              width: 160,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Text section - fixed space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        place.kabupatenKota,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(), // Push rating to bottom
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}