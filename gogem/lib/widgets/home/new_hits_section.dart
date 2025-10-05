import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/wisata_provider.dart';

class NewHitsSection extends StatelessWidget {
  const NewHitsSection({Key? key}) : super(key: key);

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
                'New Hits',
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
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.newHits.length,
            itemBuilder: (context, index) {
              final place = provider.newHits[index];
              return _buildNewHitCard(place, provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewHitCard(dynamic place, WisataProvider provider) {
    return Consumer<WisataProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => provider.navigateToDetail(context, place),
          child: Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  place.linkGambar.isNotEmpty && place.linkGambar != "No Image Available"
                      ? Image.network(
                          place.linkGambar,
                          height: 150,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: 140,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image),
                            );
                          },
                        )
                      : Container(
                          height: 150,
                          width: 140,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image),
                        ),
                  // Gradient overlay for text readability
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Text overlay
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            place.nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}