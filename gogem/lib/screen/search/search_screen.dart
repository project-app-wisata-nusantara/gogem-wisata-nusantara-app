import 'package:flutter/material.dart';
import 'package:gogem/data/model/destination_model.dart';
import 'package:gogem/screen/card/destination_card_large.dart';
import '../../provider/destination/destination_provider.dart';
import '../../style/theme/gogem_theme.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Destination> _searchResults = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DestinationProvider>(context, listen: false);
    if (provider.destinations.isEmpty) {
      provider.loadDestinations().then((_) => setState(() {}));
    }
  }

  void _performSearch(String query, List<Destination> allDestinations) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final results = allDestinations.where((dest) {
      return dest.nama.toLowerCase().contains(query.toLowerCase()) ||
          dest.kabupatenKota.toLowerCase().contains(query.toLowerCase()) ||
          dest.kategori.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<DestinationProvider>(context);
    final destinations = provider.destinations;

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
                      colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
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
                      "Cari Destinasi",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Temukan tempat wisata favoritmu 🌟",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==== SEARCH FIELD ====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ketik nama destinasi...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: GogemColors.darkGrey,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => _performSearch(value, destinations),
            ),
          ),

          // ==== LIST SEARCH RESULTS ====
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: GogemColors.primary,
                    ),
                  )
                : _searchResults.isEmpty && _controller.text.isEmpty
                ? Center(
                    child: Text(
                      "Ketik kata kunci untuk mencari destinasi...",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: GogemColors.darkGrey.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _searchResults.isEmpty
                ? Center(
                    child: Text(
                      "Destinasi tidak ditemukan 😢",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: GogemColors.darkGrey.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final dest = _searchResults[index];
                      return DestinationCardLarge(destination: dest);
                    },
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
