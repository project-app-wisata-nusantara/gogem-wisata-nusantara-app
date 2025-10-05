import 'package:flutter/material.dart';
import 'package:gogem/style/theme/gogem_theme.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // Mulai dari kiri bawah
    path.lineTo(0, size.height);
    
    // Buat lengkungan sederhana ke atas
    path.quadraticBezierTo(
      size.width / 2, // control point di tengah horizontal
      0, // control point di atas (membuat lengkungan ke atas)
      size.width, // end point di kanan
      size.height // end point di bawah kanan
    );
    
    // Tutup path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // Mulai dari kiri bawah
    path.lineTo(0, size.height);
    
    // Buat lengkungan sederhana ke atas dengan posisi sedikit berbeda
    path.quadraticBezierTo(
      size.width * 0.3, // control point agak ke kiri
      size.height * 0.2, // control point lebih ke atas
      size.width, // end point di kanan
      size.height // end point di bawah kanan
    );
    
    // Tutup path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    
    // Membuat lengkungan ke atas untuk layer bawah (oranye)
    var controlPoint = Offset(size.width * 0.5, size.height * 0.3);
    var endPoint = Offset(size.width, size.height);
    
    path.quadraticBezierTo(
      controlPoint.dx, controlPoint.dy,
      endPoint.dx, endPoint.dy
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomeSearchHeader extends StatelessWidget {
  const HomeSearchHeader({Key? key}) : super(key: key);

  Widget _buildMenuIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with wave decoration
        Stack(
          children: [
            // Main container with blue gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ Colors.white, GogemColors.primary],
                ),
              ),
              child: Column(
                children: [
                // User Info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E92F3).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'User',
                              style: TextStyle(
                                color: GogemColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E92F3).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'User@email.com',
                              style: TextStyle(
                                color: Color(0xFFFF6D00),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.person_2_outlined,
                          color: Color(0xFFFF6D00),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                // Welcome Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Welcome ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'GoGem',
                        style: TextStyle(
                          color: Color(0xFF1A1A2E),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40), // Lebih banyak space untuk welcome text
              ],
            ),
          ),
            
            // Wave decoration background 
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 40, // Kurangi tinggi wave
                  color: const Color(0xFFFF6D00),
                ),
              ),
            ),
            
            // Wave decoration - Cyan layer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopWaveClipper(),
                child: Container(
                  height: 40, // Kurangi tinggi wave
                  color: const Color(0xFF4DD0E1),
                ),
              ),
            ),
          ],
        ),

        // Search Bar floating between header and menu icons
        Transform.translate(
          offset: const Offset(0, -30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari destinasi...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF4DD0E1).withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF4DD0E1),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Menu Icons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuIcon(Icons.landscape, 'Alam', Colors.blue),
              _buildMenuIcon(Icons.account_balance, 'Bersejarah', Colors.blue),
              _buildMenuIcon(Icons.attractions, 'Hiburan', Colors.blue),
              _buildMenuIcon(Icons.restaurant, 'Kuliner', Colors.blue),
              _buildMenuIcon(Icons.apps_sharp, 'Semua', Colors.blue),
            ],
          ),
        ),
      ],
    );
  }
}