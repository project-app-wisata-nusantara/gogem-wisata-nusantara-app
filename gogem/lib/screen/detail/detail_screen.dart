import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/model/destination_model.dart';
import '../../data/ticketing_data.dart';
import '../../provider/detail/detail_provider.dart' show DetailProvider, ChatMessage;
import '../../provider/gemini/gemini_provider.dart';
import '../profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const int _maxLines = 5;
  bool _hasTriedToGenerate = false;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto-generate jika tidak ada deskripsi dan chatbot info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndGenerateSummary();
      final detailProvider = Provider.of<DetailProvider>(context, listen: false);
      detailProvider.setDestinationContext(
        widget.destination.nama,
        widget.destination.kabupatenKota,
      );
      detailProvider.generateChatbotInfo(
        destinationName: widget.destination.nama,
        location: widget.destination.kabupatenKota,
      );
    });
  }

  @override
  void didUpdateWidget(DetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset state jika destinasi berubah
    if (oldWidget.destination != widget.destination) {
      _hasTriedToGenerate = false;
      
      final detailProvider = Provider.of<DetailProvider>(context, listen: false);
      detailProvider.resetState();
      
      // Auto-generate untuk destinasi baru
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
    final hasOriginalDescription = widget.destination.deskripsi != null && 
            widget.destination.deskripsi!.trim().isNotEmpty;
    
    if (!hasOriginalDescription && !_hasTriedToGenerate) {
      _hasTriedToGenerate = true;
      final geminiProvider = Provider.of<GeminiProvider>(context, listen: false);
      
      // Clear summary sebelumnya jika ada
      geminiProvider.clearSummary();
      
      // Generate summary otomatis
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
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.destination.linkGambar.startsWith('http')
                          ? Image.network(
                              widget.destination.linkGambar,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.destination.linkGambar,
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.destination.nama,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.destination.kabupatenKota,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: () {},
                          child: const Icon(Icons.bookmark_border, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
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
              _buildRingkasanTab(),
              _buildChatbotTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanTab() {
    return Consumer<GeminiProvider>(
      builder: (context, geminiProvider, child) {
        print('🔍 Building Ringkasan Tab');
        print('   Destination: ${widget.destination.nama}');
        print('   Deskripsi: ${widget.destination.deskripsi}');
        print('   isGenerating: ${geminiProvider.isGenerating}');
        print('   generatedSummary: ${geminiProvider.generatedSummary}');
        print('   errorMessage: ${geminiProvider.errorMessage}');
        
        // Cek apakah deskripsi kosong atau null
        final bool hasOriginalDescription = widget.destination.deskripsi != null && 
                widget.destination.deskripsi!.trim().isNotEmpty;
        
        // Tentukan deskripsi yang akan ditampilkan
        final String displayDescription = hasOriginalDescription
            ? widget.destination.deskripsi!
            : geminiProvider.generatedSummary ?? '';

        print('   hasOriginalDescription: $hasOriginalDescription');

        return SingleChildScrollView(
          child: Container(
            color: const Color(0xFFFFF8E1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan loading indicator jika sedang generate
                      if (geminiProvider.isGenerating)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Memuat ringkasan...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      // Tampilkan error jika ada
                      else if (geminiProvider.errorMessage != null)
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Gagal memuat ringkasan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  geminiProvider.generateSummary(
                                    destinationName: widget.destination.nama,
                                    location: widget.destination.kabupatenKota,
                                    category: widget.destination.kategori,
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      // Tampilkan deskripsi
                      else if (displayDescription.isNotEmpty)
                        Consumer<DetailProvider>(
                          builder: (context, detailProvider, child) {
                            final isExpanded = detailProvider.isExpanded;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                  maxLines: isExpanded ? null : _maxLines,
                                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                ),
                                if (_needsReadMore(displayDescription, isExpanded))
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        detailProvider.toggleExpanded();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            isExpanded ? 'Sembunyikan' : 'Selengkapnya',
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Icon(
                                            isExpanded 
                                                ? Icons.keyboard_arrow_up 
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.orange,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        )
                      else
                        const Center(
                          child: Text(
                            'Tidak ada deskripsi tersedia.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                  const Text(
                    'Jarak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTransportIcon(Icons.directions_bike, ''),
                      _buildTransportIcon(Icons.directions_car, ''),
                      _buildTransportIcon(Icons.directions_bus, ''),
                      _buildTransportIcon(Icons.train, ''),
                      _buildTransportIcon(Icons.flight, ''),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Lokasi map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Placeholder untuk map - Anda bisa integrasikan Google Maps di sini
                          Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.map,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  bool _needsReadMore(String text, bool isExpanded) {
    final span = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
    final tp = TextPainter(
      text: span,
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 32);
    return tp.didExceedMaxLines;
  }

  Widget _buildChatbotTab() {
    return Consumer<DetailProvider>(
      builder: (context, detailProvider, child) {
        return Container(
          color: const Color(0xFFFFF8E1),
          child: Column(
            children: [
              Expanded(
                child: detailProvider.messages.isEmpty
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            if (detailProvider.isGeneratingChatbotInfo)
                              const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Memuat informasi chatbot...',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange.shade700,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        detailProvider.chatbotDescription ?? 
                                            'Tanyakan informasi tentang ${widget.destination.nama}!',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Contoh Pertanyaan:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildExampleQuestion(
                                icon: Icons.confirmation_number_outlined,
                                question: 'Dimana saya bisa membeli tiket online?',
                                onTap: () {
                                  _chatController.text = 'Dimana saya bisa membeli tiket online?';
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildExampleQuestion(
                                icon: Icons.directions_outlined,
                                question: 'Berapa lama perjalanan dari lokasi saya?',
                                onTap: () {
                                  _chatController.text = 'Berapa lama perjalanan dari lokasi saya?';
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildExampleQuestion(
                                icon: Icons.access_time_outlined,
                                question: 'Kapan wisata ini buka?',
                                onTap: () {
                                  _chatController.text = 'Kapan wisata ini buka?';
                                },
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: detailProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = detailProvider.messages[index];
                          return _buildChatBubble(message);
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: 'Tanyakan ......',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.orange),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            detailProvider.sendMessage(value);
                            _chatController.clear();
                            // Scroll to bottom setelah kirim pesan
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: detailProvider.isSendingMessage 
                            ? Colors.grey 
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: detailProvider.isSendingMessage
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
                        onPressed: detailProvider.isSendingMessage
                            ? null
                            : () {
                                final message = _chatController.text;
                                if (message.trim().isNotEmpty) {
                                  detailProvider.sendMessage(message);
                                  _chatController.clear();
                                  // Scroll to bottom setelah kirim pesan
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (_scrollController.hasClients) {
                                      _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    // Check apakah ini response tentang platform tiket
    final isPlatformResponse = !message.isUser && 
        message.text.contains('Berikut rekomendasi platform');
    
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: message.isUser 
              ? Colors.orange.shade100 
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: message.isUser 
                ? Colors.orange.shade200 
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPlatformResponse)
              _buildPlatformList()
            else
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎫 Rekomendasi Platform Tiket Wisata',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...TicketingData.platforms.map((platform) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        platform.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 18),
                      color: Colors.blue,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        final uri = Uri.parse(platform.url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          // Copy to clipboard sebagai fallback
                          await Clipboard.setData(ClipboardData(text: platform.url));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Link ${platform.name} disalin!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  platform.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: platform.url));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Link ${platform.name} disalin!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.link, size: 14, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            platform.url,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue[700],
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tips: Bandingkan harga di beberapa platform untuk deal terbaik!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExampleQuestion({
    required IconData icon,
    required String question,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportIcon(IconData icon, String distance) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue,
          child: Icon(icon, color: Colors.white),
        ),
        if (distance.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            distance,
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ],
      ],
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFFFF8E1),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}