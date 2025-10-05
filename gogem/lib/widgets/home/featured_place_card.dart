import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/wisata_provider.dart';

class FeaturedPlaceCard extends StatelessWidget {
  const FeaturedPlaceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WisataProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          if (provider.featuredPlace != null) {
            provider.navigateToDetail(context, provider.featuredPlace!);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              provider.featuredPlace != null
                  ? Image.network(
                      provider.featuredPlace!.linkGambar,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    provider.featuredPlace?.nama ?? 'Loading...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (provider.featuredPlace != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                          provider.featuredPlace!.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
  }
}