// lib/screen/profile/faq_screen.dart
import 'package:flutter/material.dart';
// Import kelas tema dan warna yang Anda sediakan
import 'package:gogem/style/theme/gogem_theme.dart';
// Asumsi path ini adalah yang benar ke file GogemColors dan GogemTheme Anda

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  // Data dummy untuk FAQ (Pertanyaan dan Jawaban)
  final List<Map<String, String>> faqData = const [
    {
      'question': 'Apa itu Aplikasi GoGem?',
      'answer':
          'GoGem adalah sebuah aplikasi virtual tour guide berbasis mobile yang dirancang untuk mengatasi kesulitan wisatawan dalam menemukan informasi wisata yang lengkap, terintegrasi, dan mudah diakses di Indonesia.',
    },
    {
      'question': 'Bagaimana cara mendaftar/login?',
      'answer':
          'Berikut merupakan beberapa fitur utama dalam aplikasi GoGem :\n- Daftar Destinasi Wisata → menampilkan informasi wisata, kuliner, pusat oleh-oleh, hingga hidden gems.\n- Detail Destinasi → berisi foto, lokasi, rating, jam buka, dan deskripsi singkat.\n- Peta Interaktif → integrasi dengan Google Maps untuk navigasi dan rute perjalanan.\n- Wishlist & Review → wisatawan dapat menyimpan destinasi favorit serta berbagi ulasan.\n- Chatbot Asisten Wisata → didukung Gemini API untuk menjawab pertanyaan dan memberikan rekomendasi destinasi secara personal.',
    },
    {
      'question':
          'Apakah Aplikasi GoGem ini bisa digunakan tanpa koneksi internet?',
      'answer':
          'Tidak, aplikasi GoGem tidak dapat berfungsi secara penuh tanpa koneksi internet',
    },
    {
      'question': 'Bagaimana cara mengunduh aplikasi ini?',
      'answer':
          'Anda dapat mengunduhnya melalui Google Play Store untuk perangkat Android dan App Store untuk perangkat iOS.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: faqData.map((item) {
            return Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                iconColor: colorScheme.primary,
                collapsedIconColor: colorScheme.onBackground.withOpacity(0.6),

                title: Text(
                  item['question']!,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      item['answer']!,
                      textAlign: TextAlign.justify,
                      style: textTheme.bodySmall?.copyWith(
                        color: GogemColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
