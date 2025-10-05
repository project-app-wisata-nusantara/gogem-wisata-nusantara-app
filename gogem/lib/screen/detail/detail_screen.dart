import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/wisata_model.dart';

// Provider untuk Detail Screen
class DetailProvider extends ChangeNotifier {
  int _selectedTab = 0;
  bool _isFavorite = false;

  int get selectedTab => _selectedTab;
  bool get isFavorite => _isFavorite;

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

// Detail Screen Widget
class DetailScreen extends StatelessWidget {
  final PlaceDetailModel place;

  const DetailScreen({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProvider(),
      child: DetailScreenContent(place: place),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  final PlaceDetailModel place;

  const DetailScreenContent({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                Stack(
                  children: [
                    Image.network(
                      place.imageUrl,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 280,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 50),
                        );
                      },
                    ),
                    // Gradient Overlay
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Back and Profile Button
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black87,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xFFFF8C42),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Title and Location
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place.location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Rating Badge
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8C42),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      bottom: 60,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF1E5EFF),
                        radius: 24,
                        child: IconButton(
                          icon: Icon(
                            provider.isFavorite
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          onPressed: provider.toggleFavorite,
                        ),
                      ),
                    ),
                  ],
                ),

                // Tab Navigation
                Container(
                  color: const Color(0xFFFFF8F0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => provider.setSelectedTab(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: provider.selectedTab == 0
                                      ? const Color(0xFF1E5EFF)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'Ringkasan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: provider.selectedTab == 0
                                    ? const Color(0xFF1E5EFF)
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: provider.selectedTab == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => provider.setSelectedTab(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: provider.selectedTab == 1
                                      ? const Color(0xFFFF8C42)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'Chatbot',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: provider.selectedTab == 1
                                    ? const Color(0xFFFF8C42)
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: provider.selectedTab == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Area
                Container(
                  color: const Color(0xFFFFF8F0),
                  padding: const EdgeInsets.all(16),
                  child: provider.selectedTab == 0
                      ? _buildRingkasanTab()
                      : _buildChatbotTab(),
                ),
              ],
            ),
          ),

          // Chat Input (only visible on Chatbot tab)
          if (provider.selectedTab == 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildChatInput(),
            ),
        ],
      ),
    );
  }

  Widget _buildRingkasanTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          place.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),

        // History/Additional Info
        if (place.historyDescription.isNotEmpty) ...[
          Text(
            place.historyDescription,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selengkapnya...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFF8C42),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Transportation Section
        const Text(
          'Jarak',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Transportation Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTransportIcon(Icons.directions_bike, '2 j 38 m'),
            _buildTransportIcon(Icons.directions_car, '2 j 49 m'),
            _buildTransportIcon(Icons.directions_bus, '-'),
            _buildTransportIcon(Icons.train, '-'),
            _buildTransportIcon(Icons.flight, '-'),
          ],
        ),
        const SizedBox(height: 24),

        // Map Section
        const Text(
          'Lokasi map',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Map Container (Placeholder)
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Placeholder map - bisa diganti dengan Google Maps atau MapBox
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 50,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Map View',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Location marker
                const Center(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildChatbotTab() {
    return const Column(
      children: [
        SizedBox(height: 100),
        Center(
          child: Text(
            'Mulai percakapan dengan chatbot\nuntuk mendapatkan informasi lebih lanjut',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 300),
      ],
    );
  }

  Widget _buildTransportIcon(IconData icon, String duration) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF1E5EFF),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          duration,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1E5EFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFF1E5EFF)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tanyakan ......',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage dengan dummy data
class ExampleDetailScreen extends StatelessWidget {
  const ExampleDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dummyPlace = PlaceDetailModel(
      name: 'Masjid Raya Baiturrahman',
      location: 'Kota Banda Aceh, Aceh.',
      rating: 4.5,
      imageUrl: 'https://picsum.photos/800/600?random=1',
      description:
          'Masjid Raya Baiturrahman adalah ikon megah di Banda Aceh. Arsitekturnya yang indah dengan kubah-kubah putih dan halaman yang luas membuatnya sangat tenang untuk beribadah dan refleksi.',
      historyDescription:
          'Masjid Raya Baiturrahman di Banda Aceh dibangun pada tahun 1612 oleh Sultan Iskandar Muda, meskipun ada catatan bahwa masjid ini mungkin sudah berdiri sejak 1292. Masjid ini merupakan simbol kejayaan Kesultanan Aceh dan telah mengalami beberapa renovasi selama berabad-abad. Pada tahun 1873, masjid ini dibakar oleh pasukan Belanda namun dibangun kembali',
      latitude: 5.5577,
      longitude: 95.3222,
    );

    return DetailScreen(place: dummyPlace);
  }
}