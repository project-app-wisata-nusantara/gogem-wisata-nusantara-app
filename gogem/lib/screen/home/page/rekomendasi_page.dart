import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/destination_model.dart';
import '../../../provider/recommender/recommender_provider.dart';
import '../../card/destination_card_large.dart';
import '../../../style/theme/gogem_theme.dart';

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late List<Destination> _recommendations;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      // Delay kecil supaya animasi lebih smooth
      await Future.delayed(const Duration(milliseconds: 500));

      final recommender = Provider.of<RecommenderProvider>(
        context,
        listen: false,
      );

      // Tunggu sampai recommender selesai load
      if (recommender.isLoading) {
        await recommender.initialize();
      }

      setState(() {
        _recommendations = recommender.getTopRecommendations(topN: 20);
        _isLoading = false;
      });

      _controller.forward();
    } catch (e) {
      debugPrint("Error loading recommendations: $e");
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
                        Color(0xFF1976D2), // biru tua
                        Color(0xFF42A5F5), // biru muda
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
                      "Rekomendasi Untukmu",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Destinasi yang cocok untukmu ✨",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
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
                        top: 8,
                        left: 12,
                        right: 12,
                        bottom: 24,
                      ),
                      itemCount: _recommendations.length,
                      itemBuilder: (context, index) {
                        final dest = _recommendations[index];
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
