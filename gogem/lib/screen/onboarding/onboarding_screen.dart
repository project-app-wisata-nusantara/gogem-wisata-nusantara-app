import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": "assets/onboarding-1.jpg",
      "title": "Welcome & Intro",
      "desc": "Selamat datang di GoGem!\nTemukan cara baru menjelajah Indonesia dengan Smart Virtual Tour Guide yang interaktif dan personal.",
      "button": "Let's Go",
    },
    {
      "image": "assets/onboarding-2.jpg",
      "title": "Hidden Gems & Local Wonders",
      "desc": "Jangan hanya ke destinasi populer.\nGoGem membawamu menemukan hidden gems, kuliner autentik, hingga produk lokal yang jarang terungkap wisatawan.",
      "button": "Continue",
    },
    {
      "image": "assets/onboarding-1.jpg",
      "title": "Smart Virtual AI Tour Guide",
      "desc": "Jelajahi destinasi dengan lebih mudah bersama Smart Virtual AI dari GoGem yang siap membantu Anda kapan saja.",
      "button": "Let's Start",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_pages[index]["image"]!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pages[index]["title"]!,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pages[index]["desc"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (index == _pages.length - 1) {
                            // TODO: Arahkan ke Home Page
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child: Text(
                          _pages[index]["button"]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            },
          ),
          // indikator dots
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.orange
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
