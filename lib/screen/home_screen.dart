import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/home/home_provider.dart';
import '../screen/home/home_content.dart';
import '../screen/map/maps_screen.dart';
import '../screen/favorite/favorite_screen.dart';
import '../screen/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _pages = const [
    HomeContent(),
    MapsScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      body: _pages[provider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        onTap: provider.setIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: "Maps"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Favorit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
