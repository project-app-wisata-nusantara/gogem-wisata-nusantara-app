import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/wisata_provider.dart';
import '../../widgets/home/home_search_header.dart';
import '../../widgets/home/featured_place_card.dart';
import '../../widgets/home/popular_places_section.dart';
import '../../widgets/home/new_hits_section.dart';
import '../../widgets/home/home_bottom_nav_bar.dart';

// Home Screen Widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WisataProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WisataProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: provider.isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E5EFF)),
              ),
            )
          : provider.hasError
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage ?? 'Terjadi kesalahan'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.initializeWisataData(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Header Section
                    HomeSearchHeader(),
                    
                    // Featured Place Card
                    FeaturedPlaceCard(),
                    
                    // Popular Places Section
                    PopularPlacesSection(),
                    
                    // New Hits Section
                    NewHitsSection(),
                    
                    SizedBox(height: 100), // Bottom padding for navigation bar
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}