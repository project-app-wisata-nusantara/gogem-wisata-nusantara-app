import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogem/screen/detail/detail_screen.dart';
import 'package:provider/provider.dart';
import '../../data/model/destination_model.dart';
import '../../provider/category/category_provider.dart';
import 'package:gogem/widget/card/destination_card.dart';
import '../profile/profile_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Destination> destinations = [];
  bool isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDestinations();
    Future.microtask(
      () => Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadCategories(),
    );
  }

  Future<void> _loadDestinations() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/dataset.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    final List<Destination> loadedDestinations = jsonData
        .map((e) => Destination.fromJson(e))
        .toList();

    setState(() {
      destinations = loadedDestinations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final List<String> imgList = [
      'assets/images/onboarding-1.jpg',
      'assets/images/onboarding-2.jpg',
      'assets/images/onboarding-3.png',
      'assets/images/onboarding-1.jpg',
    ];

    // Filter untuk search
    final filteredDestinations = destinations
        .where((d) => d.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Algoritma rating
    final List<Destination> populer = List.from(destinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final List<Destination> newHits = populer.length > 5
        ? populer.sublist(3, 7)
        : populer.take(3).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER + SEARCH =====
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bg_header.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Welcome GoGem",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user?.email ?? '',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Discover hidden gems & local wonders",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProfileScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.blueAccent,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SEARCH BAR
                        Positioned(
                          bottom: -25,
                          left: 20,
                          right: 20,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              onChanged: (value) =>
                                  setState(() => _searchQuery = value),
                              decoration: const InputDecoration(
                                hintText: 'Cari destinasi...',
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // ===== SEARCH RESULTS / HOME CONTENT =====
                    _searchQuery.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionTitle(title: "Hasil Pencarian"),
                              const SizedBox(height: 8),
                              filteredDestinations.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Center(
                                        child: Text(
                                          "Tidak ada destinasi yang cocok.",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 240,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        itemCount: filteredDestinations.length,
                                        itemBuilder: (context, index) {
                                          final dest =
                                              filteredDestinations[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => DetailScreen(
                                                    destination: dest,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: DestinationCard(
                                              destination: dest,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              const SizedBox(height: 24),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ===== KATEGORI =====
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: categoryProvider.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 12,
                                              childAspectRatio: 0.85,
                                            ),
                                        itemCount:
                                            categoryProvider.categories.length,
                                        itemBuilder: (context, index) {
                                          final kategori = categoryProvider
                                              .categories[index];
                                          return _CategoryItem(
                                            icon: _getCategoryIcon(kategori),
                                            label: kategori,
                                          );
                                        },
                                      ),
                              ),

                              const SizedBox(height: 24),

                              // ===== SLIDER DESTINASI =====
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: 180,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 800,
                                    ),
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.85,
                                    aspectRatio: 16 / 9,
                                    initialPage: 0,
                                  ),
                                  items: imgList.map((item) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.15,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.asset(
                                                  item,
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black
                                                            .withValues(alpha: 0.15),
                                                        Colors.transparent,
                                                      ],
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 16,
                                                  bottom: 16,
                                                  child: Text(
                                                    item
                                                        .split('/')
                                                        .last
                                                        .split('.')
                                                        .first
                                                        .replaceAll('_', ' ')
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black54,
                                                          blurRadius: 4,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // ===== POPULER =====
                              const _SectionTitle(title: "Populer"),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 240,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 16),
                                  itemCount: populer.length > 5
                                      ? 5
                                      : populer.length,
                                  itemBuilder: (context, index) {
                                    final dest = populer[index];
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
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ===== NEW HITS =====
                              const _SectionTitle(title: "New Hits"),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 240,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 16),
                                  itemCount: newHits.length,
                                  itemBuilder: (context, index) {
                                    final dest = newHits[index];
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
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ===== HELPER & WIDGET =====
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
  const _CategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 30),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Lainnya..",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
