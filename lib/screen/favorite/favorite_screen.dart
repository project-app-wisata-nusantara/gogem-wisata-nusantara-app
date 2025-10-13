import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gogem/provider/home/home_provider.dart';
import 'package:gogem/provider/favorite/favorite_provider.dart';
import 'package:gogem/widget/card/favorite_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    await provider.loadFavorites();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final provider = context.read<HomeProvider>();
            provider.setIndex(0); // kembali ke tab Home
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? const Center(child: Text("Belum ada destinasi favorit."))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return FavoriteCard(destination: favorites[index]);
        },
      ),
    );
  }
}
