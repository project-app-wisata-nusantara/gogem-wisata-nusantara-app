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
      'answer': 'GoGem adalah aplikasi yang membantu Anda menemukan lokasi tambang atau sumber daya alam terdekat di sekitar Anda.',
    },
    {
      'question': 'Bagaimana cara mendaftar/login?',
      'answer': 'Anda dapat mendaftar dengan email dan kata sandi, atau menggunakan akun Google/Facebook Anda di halaman Autentikasi.',
    },
    {
      'question': 'Apakah data lokasi yang ditampilkan akurat?',
      'answer': 'Kami berusaha menampilkan data yang paling akurat dari sumber terpercaya, namun disarankan untuk memverifikasi ulang di lapangan.',
    },
    {
      'question': 'Bagaimana cara mengubah tema aplikasi?',
      'answer': 'Anda bisa mengubah tema aplikasi melalui menu "Tema" di halaman profil.',
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
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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