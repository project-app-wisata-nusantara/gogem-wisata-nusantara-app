import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../style/theme/gogem_theme.dart';

class HomeCarousel extends StatelessWidget {
  final List<Map<String, String>> banners = [
    {
      'image': 'assets/images/slider_1.png',
      'title': 'Jelajahi Pesona Indonesia',
      'subtitle': 'Temukan keindahan alam dan budaya Nusantara yang memukau ✨',
    },
    {
      'image': 'assets/images/slider_2.png',
      'title': 'Kamu Akan Menyesal!',
      'subtitle':
          'Menyesal karena tidak pernah menjelajahi keajaiban Indonesia 🌋',
    },
    {
      'image': 'assets/images/slider_3.png',
      'title': 'Mengenal Budaya Indonesia',
      'subtitle': 'Kekayaan tradisi dan tarian dari Sabang sampai Merauke 🎭',
    },
    {
      'image': 'assets/images/slider_4.png',
      'title': 'Jelajahi Indonesia',
      'subtitle':
          'Rasakan pengalaman tak terlupakan di hutan dan pantai Indonesia 🌊',
    },
  ];

  HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 190,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          viewportFraction: 0.85,
          aspectRatio: 16 / 9,
          initialPage: 0,
        ),
        items: banners.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: GogemColors.darkGrey.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // === Background Image ===
                      Image.asset(banner['image']!, fit: BoxFit.cover),

                      // === Gradient Overlay ===
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              GogemColors.primary.withValues(alpha: 0.55),
                              Colors.transparent,
                              GogemColors.backgroundDark.withValues(
                                alpha: 0.45,
                              ),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),

                      // === Text Box (menempel di bawah) ===
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner['title']!,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: GogemColors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner['subtitle']!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: GogemColors.white.withValues(
                                    alpha: 0.9,
                                  ),
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === Border aesthetic ===
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GogemColors.white.withValues(alpha: 0.15),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(22),
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
    );
  }
}
