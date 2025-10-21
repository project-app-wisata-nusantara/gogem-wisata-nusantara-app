import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogem/data/model/destination_model.dart';
import 'package:gogem/screen/card/destination_card_large.dart';
import 'package:gogem/style/theme/gogem_theme.dart';

class NewHitsPage extends StatefulWidget {
  const NewHitsPage({super.key});

  @override
  State<NewHitsPage> createState() => _NewHitsPageState();
}

class _NewHitsPageState extends State<NewHitsPage>
    with SingleTickerProviderStateMixin {
  List<Destination> _newHitsList = [];
  bool _isLoading = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      final jsonString =
      await rootBundle.loadString('assets/data/dataset.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final destinations =
      jsonData.map((e) => Destination.fromJson(e)).toList();

      // Urutkan berdasarkan rating tertinggi
      destinations.sort((a, b) => b.rating.compareTo(a.rating));

      setState(() {
        _newHitsList =
        destinations.length > 20 ? destinations.sublist(0, 20) : destinations;
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  Widget _buildLoadingEffect() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GogemColors.backgroundLight,
      body: Column(
        children: [
          // ==== HEADER CUSTOM ====
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
                      "Destinasi New Hits",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tempat baru yang lagi naik daun 🌟",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==== LIST CONTENT ====
          Expanded(
            child: _isLoading
                ? _buildLoadingEffect()
                : FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 8, left: 12, right: 12, bottom: 24),
                itemCount: _newHitsList.length,
                itemBuilder: (context, index) {
                  final dest = _newHitsList[index];
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
