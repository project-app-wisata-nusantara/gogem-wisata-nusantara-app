import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gogem/data/model/destination_model.dart';
import 'package:gogem/screen/detail/detail_screen.dart';
import '../../provider/favorite/favorite_provider.dart';
import '../../style/theme/gogem_theme.dart';

class DestinationCardLarge extends StatefulWidget {
  final Destination destination;

  const DestinationCardLarge({super.key, required this.destination});

  @override
  State<DestinationCardLarge> createState() => _DestinationCardLargeState();
}

class _DestinationCardLargeState extends State<DestinationCardLarge> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // cek apakah destinasi ini sudah favorit
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    provider.isFavorite(widget.destination.id).then((value) {
      if (mounted) setState(() => isFavorite = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<FavoriteProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(destination: widget.destination),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: GogemColors.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==== IMAGE & OVERLAY ====
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
                  child: widget.destination.linkGambar.startsWith('http')
                      ? Image.network(
                    widget.destination.linkGambar,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    widget.destination.linkGambar,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),

            // ==== DETAIL & FAVORITE BUTTON ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14).copyWith(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination.nama,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: GogemColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.destination.kabupatenKota,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: GogemColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                widget.destination.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // FAVORITE BUTTON
                  GestureDetector(
                    onTap: () async {
                      await provider.toggleFavorite(widget.destination);
                      final favStatus = await provider.isFavorite(widget.destination.id);
                      if (mounted) setState(() => isFavorite = favStatus);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFavorite ? GogemColors.primary : GogemColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isFavorite ? GogemColors.white : GogemColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
