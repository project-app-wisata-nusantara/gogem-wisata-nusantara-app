// lib/screens/detail/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:gogem/screen/detail/widgets/chatbot_content.dart';
import 'package:gogem/screen/detail/widgets/detail_app_bar.dart';
import 'package:gogem/screen/detail/widgets/ringkasan_content.dart';
import 'package:gogem/screen/detail/widgets/sticky_tab_bar_delegate.dart';
import 'package:provider/provider.dart';
import '../../data/model/destination_model.dart';
import '../../provider/detail/detail_provider.dart' show DetailProvider;
import '../../provider/gemini/gemini_provider.dart';
import '../../provider/map/map_provider.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _hasTriedToGenerate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndGenerateSummary();
      final detailProvider = Provider.of<DetailProvider>(
        context,
        listen: false,
      );
      detailProvider.setDestinationContext(
        widget.destination.nama,
        widget.destination.kabupatenKota,
      );
      detailProvider.generateChatbotInfo(
        destinationName: widget.destination.nama,
        location: widget.destination.kabupatenKota,
      );
      final mapProvider = context.read<MapProvider>();
      if (mapProvider.markers.isEmpty) {
        mapProvider.loadDestinations();
      }
    });
  }

  @override
  void didUpdateWidget(DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destination != widget.destination) {
      _hasTriedToGenerate = false;

      final detailProvider = Provider.of<DetailProvider>(
        context,
        listen: false,
      );
      detailProvider.resetState();

      _checkAndGenerateSummary();
      detailProvider.setDestinationContext(
        widget.destination.nama,
        widget.destination.kabupatenKota,
      );
      detailProvider.generateChatbotInfo(
        destinationName: widget.destination.nama,
        location: widget.destination.kabupatenKota,
      );
    }
  }

  void _checkAndGenerateSummary() {
    final hasOriginalDescription =
        widget.destination.deskripsi != null &&
        widget.destination.deskripsi!.trim().isNotEmpty;

    if (!hasOriginalDescription && !_hasTriedToGenerate) {
      _hasTriedToGenerate = true;
      final geminiProvider = Provider.of<GeminiProvider>(
        context,
        listen: false,
      );

      geminiProvider.clearSummary();

      geminiProvider.generateSummary(
        destinationName: widget.destination.nama,
        location: widget.destination.kabupatenKota,
        category: widget.destination.kategori,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Menggunakan widget yang dipisahkan
              DetailAppBar(destination: widget.destination),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  TabBar(
                    indicatorColor: Colors.orange,
                    labelColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Ringkasan'),
                      Tab(text: 'Chatbot'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Menggunakan widget yang dipisahkan
              RingkasanContent(destination: widget.destination),
              ChatbotContent(destination: widget.destination),
            ],
          ),
        ),
      ),
    );
  }
}
