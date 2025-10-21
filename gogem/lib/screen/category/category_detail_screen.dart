import 'package:flutter/material.dart';
import '../../../data/model/destination_model.dart';
import '../../../style/theme/gogem_theme.dart';
import '../card/destination_card.dart';
import '../card/destination_card_large.dart';
import '../detail/detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String kategori;
  final List<Destination> destinations;

  const CategoryDetailScreen({
    super.key,
    required this.kategori,
    required this.destinations,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GogemColors.backgroundLight,
      body: Column(
        children: [
          // ==== HEADER CUSTOM ala NewHitsPage ====
          Stack(
            children: [
              ClipPath(
                clipper: HeaderWaveClipper(),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF8E24AA), // ungu tua
                        Color(0xFFBA68C8), // ungu muda
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 50,
                left: 70,
                bottom: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kategori: ${widget.kategori}",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.destinations.length} Destinasi tersedia",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                right: 16,
                child: IconButton(
                  icon: Icon(isGrid ? Icons.list : Icons.grid_view,
                      color: Colors.white),
                  onPressed: () => setState(() => isGrid = !isGrid),
                ),
              ),
            ],
          ),

          // ==== LIST / GRID CONTENT ====
          Expanded(
            child: widget.destinations.isEmpty
                ? Center(
              child: Text(
                "Belum ada destinasi untuk kategori ini 😢",
                style: theme.textTheme.titleMedium,
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: isGrid
                  ? GridView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: widget.destinations.length,
                itemBuilder: (context, index) {
                  final dest = widget.destinations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(destination: dest),
                        ),
                      );
                    },
                    child: DestinationCard(destination: dest),
                  );
                },
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                itemCount: widget.destinations.length,
                itemBuilder: (context, index) {
                  final dest = widget.destinations[index];
                  return DestinationCardLarge(destination: dest);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==== CUSTOM CLIPPER UNTUK HEADER WAVE ====
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
