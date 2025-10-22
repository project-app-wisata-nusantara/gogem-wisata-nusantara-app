import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/category/category_provider.dart';
import '../../../provider/destination/destination_provider.dart';
import '../../../style/theme/gogem_theme.dart';
import '../../../data/model/destination_model.dart';
import '../../category/category_detail_screen.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final destinationProvider = context.watch<DestinationProvider>();
    Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final kategori = categoryProvider.categories[index];
                return _CategoryItem(
                  icon: _getCategoryIcon(kategori),
                  label: kategori,
                  onTap: () {
                    // Ambil destinasi sesuai kategori
                    final List<Destination> filtered = destinationProvider
                        .destinations
                        .where(
                          (d) =>
                              d.kategori.toLowerCase() ==
                              kategori.toLowerCase(),
                        )
                        .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(
                          kategori: kategori,
                          destinations: filtered,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

IconData _getCategoryIcon(String kategori) {
  switch (kategori.toLowerCase()) {
    case 'alam':
      return Icons.landscape_rounded;
    case 'budaya':
      return Icons.temple_hindu_rounded;
    case 'rekreasi':
      return Icons.beach_access_rounded;
    case 'umum':
      return Icons.account_balance_rounded;
    default:
      return Icons.place_rounded;
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        GogemColors.secondary.withValues(alpha: 0.6),
                        GogemColors.accent.withValues(alpha: 0.7),
                      ]
                    : [
                        GogemColors.primary.withValues(alpha: 0.85),
                        GogemColors.secondary.withValues(alpha: 0.85),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: GogemColors.darkGrey.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: GogemColors.white, size: 30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: GogemColors.textLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
