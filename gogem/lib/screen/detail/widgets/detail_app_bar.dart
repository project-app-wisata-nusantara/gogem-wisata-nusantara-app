import 'package:flutter/material.dart';
import 'package:gogem/screen/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../data/model/destination_model.dart';
import '../../../provider/favorite/favorite_provider.dart';
import '../../../style/theme/gogem_theme.dart';
import '../../../style/typography/gogem_text_styles.dart';
import '../../profile/profile_screen.dart';

class DetailAppBar extends StatefulWidget {
  final Destination destination;

  const DetailAppBar({super.key, required this.destination});

  @override
  State<DetailAppBar> createState() => _DetailAppBarState();
}

class _DetailAppBarState extends State<DetailAppBar> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah destinasi ini sudah difavoritkan
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    provider.isFavorite(widget.destination.id).then((value) {
      if (mounted) setState(() => isFavorite = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 6,
      backgroundColor: GogemColors.backgroundLight,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // === Gambar utama ===
            widget.destination.linkGambar.startsWith('http')
                ? Image.network(
                    widget.destination.linkGambar,
                    fit: BoxFit.cover,
                  )
                : Image.asset(widget.destination.linkGambar, fit: BoxFit.cover),

            // === Overlay gradient ===
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GogemColors.backgroundDark.withValues(alpha: 0.6),
                    Colors.transparent,
                    GogemColors.backgroundDark.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            // === Info destinasi ===
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: GogemColors.white.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GogemColors.darkGrey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.nama,
                      style: GogemTextStyles.titleLarge.copyWith(
                        color: GogemColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: GogemColors.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.destination.kabupatenKota,
                            style: GogemTextStyles.bodyLargeMedium.copyWith(
                              color: GogemColors.darkGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: GogemColors.accent,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // === Tombol Bookmark ===
            Positioned(
              bottom: 22,
              right: 16,
              child: GestureDetector(
                onTap: () async {
                  await provider.toggleFavorite(widget.destination);
                  final favStatus = await provider.isFavorite(
                    widget.destination.id,
                  );
                  if (mounted) setState(() => isFavorite = favStatus);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? GogemColors.primary
                        : GogemColors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isFavorite ? GogemColors.white : GogemColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // === Tombol navigasi Home & Profile ===
      leading: Padding(
        padding: const EdgeInsets.all(7.0),
        child: CircleAvatar(
          backgroundColor: GogemColors.white.withValues(alpha: 0.95),
          child: IconButton(
            icon: const Icon(
              Icons.home_rounded,
              color: GogemColors.accent,
              size: 26,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: CircleAvatar(
            backgroundColor: GogemColors.white.withValues(alpha: 0.95),
            child: IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
                color: GogemColors.primary,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
