import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gogem/screen/card/destination_card_large.dart';
import '../../provider/favorite/favorite_provider.dart';
import '../../style/theme/gogem_theme.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the loadFavorites call after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FavoriteProvider>(context, listen: false);
      provider.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      backgroundColor: GogemColors.backgroundLight,
      body: Column(
        children: [
          // ==== HEADER WAVE ====
          Stack(
            children: [
              ClipPath(
                clipper: HeaderWaveClipper(),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                bottom: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Favoritku",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tempat wisata favoritmu disini 🌟",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==== LIST FAVORITES ====
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: GogemColors.primary,
                    ),
                  )
                : favorites.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada destinasi favorit 😢",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GogemColors.darkGrey.withValues(alpha: 0.8),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 8),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final dest = favorites[index];
                      return Dismissible(
                        key: ValueKey(dest.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onDismissed: (direction) async {
                          await provider.toggleFavorite(dest);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${dest.nama} dihapus dari favorit',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: DestinationCardLarge(destination: dest),
                      );
                    },
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
