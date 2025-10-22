import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogem/screen/detail/detail_screen.dart';
import 'package:gogem/screen/home/page/new_hits_page.dart';
import 'package:gogem/screen/home/page/populer_page.dart';
import 'package:gogem/screen/home/page/rekomendasi_page.dart';
import 'package:gogem/screen/home/widgets/category_section.dart';
import 'package:gogem/screen/home/widgets/home_carousel.dart';
import 'package:gogem/screen/search/search_screen.dart';
import 'package:provider/provider.dart';
import '../../data/model/destination_model.dart';
import '../../provider/category/category_provider.dart';
import '../../provider/recommender/recommender_provider.dart';
import '../card/destination_card.dart';
import '../profile/profile_screen.dart';
import 'package:gogem/style/typography/gogem_text_styles.dart';
import 'package:gogem/style/theme/gogem_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Destination> destinations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();

    // provider kategori
    Future.microtask(
      () => Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadCategories(),
    );

    // recommender model
    Future.microtask(
      () =>
          Provider.of<RecommenderProvider>(context, listen: false).initialize(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialogOnce();
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _showWelcomeDialogOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShown = prefs.getBool('hasShownWelcome') ?? false;

    if (!hasShown) {
      _showWelcomeDialog(context);
      await prefs.setBool('hasShownWelcome', true);
    }
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
    //final categoryProvider = Provider.of<CategoryProvider>(context);

    final recommender = Provider.of<RecommenderProvider>(context);

    // --- Algoritma rating ---
    final List<Destination> populer = List.from(destinations)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final List<Destination> newHits = populer.length > 5
        ? populer.sublist(3, 7)
        : populer.take(3).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.colorScheme.surface,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== HEADER =====
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  GogemColors.primary,
                                  GogemColors.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/bg_header.png',
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                opacity: 0.15,
                              ),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(26),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // === USER INFO TEXT ===
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.email ?? 'User',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: GogemColors.white
                                                  .withValues(alpha: 0.9),
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Welcome GoGem",
                                        style: theme.textTheme.headlineLarge
                                            ?.copyWith(
                                              color: GogemColors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Discover hidden gems & local wonders",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: GogemColors.white
                                                  .withValues(alpha: 0.85),
                                              fontSize: 15,
                                              height: 1.3,
                                            ),
                                      ),
                                    ],
                                  ),

                                  // === PROFILE BUTTON MODERN ===
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
                                        gradient: const LinearGradient(
                                          colors: [
                                            GogemColors.accent,
                                            GogemColors.secondary,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: GogemColors.darkGrey
                                                .withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: GogemColors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ==== SEARCH BAR FLOATING ====
                          Positioned(
                            bottom: -25,
                            left: 20,
                            right: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SearchScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: GogemColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: GogemColors.darkGrey.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: GogemColors.darkGrey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Cari destinasi...',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: GogemColors.darkGrey
                                                .withValues(alpha: 0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // ===== KATEGORI =====
                      const CategorySection(),

                      const SizedBox(height: 5),
                      // ===== SLIDER DESTINASI =====
                      HomeCarousel(),
                      const SizedBox(height: 5),

                      // ===== POPULER =====
                      SectionTitle(
                        title: "Populer",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PopulerPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          itemCount: populer.length > 5 ? 5 : populer.length,
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

                      const SizedBox(height: 12),

                      // ===== NEW HITS =====
                      SectionTitle(
                        title: "New Hits",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NewHitsPage(),
                            ),
                          );
                        },
                      ),
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
                      const SizedBox(height: 12),
                      // ===== REKOMENDASI MODEL =====
                      if (!recommender.isLoading) ...[
                        SectionTitle(
                          title: "Rekomendasi Untukmu ✨",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RekomendasiPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: recommender
                                .getTopRecommendations(topN: 10)
                                .length,
                            itemBuilder: (context, index) {
                              final dest = recommender.getTopRecommendations(
                                topN: 10,
                              )[index];
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
                      ] else ...[
                        const Center(child: CircularProgressIndicator()),
                      ],

                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

void _showWelcomeDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      final theme = Theme.of(context);
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Drag indicator ---
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // --- Judul ---
              Text(
                "Selamat Bergabung!",
                style: GogemTextStyles.headlineMedium.copyWith(
                  color: GogemColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // --- Subjudul ---
              Text(
                "Siapkan dirimu untuk menemukan Surga Wisata di Indonesia.",
                textAlign: TextAlign.center,
                style: GogemTextStyles.bodyLargeMedium.copyWith(
                  color: GogemColors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 28),

              // --- Tombol Jelajahi ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GogemColors.accent, // oranye dari theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Jelajahi sekarang",
                  style: GogemTextStyles.bodyLargeBold.copyWith(
                    color: GogemColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

// ===== SECTION TITLE =====
class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: GogemColors.textLight,
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              "Lainnya..",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: GogemColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
