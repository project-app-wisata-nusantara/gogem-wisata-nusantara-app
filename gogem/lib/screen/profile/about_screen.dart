import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Data konstan aplikasi
  static const String appVersion = '1.0.2';
  static const String supportEmail = 'support@gogem.id';

  // Data Tim Pengembang (4 Orang)
  final List<Map<String, String>> teamMembers = const [
    {
      'name': 'Setyadi Darmawan',
      'role': 'BC25B078',
      'email': 'BC25B078@gogem.id',
      'photo': 'assets/images/team/team01.png',
    },
    {
      'name': 'Revina Chitra Sagita',
      'role': 'Mobile Developer (Flutter)',
      'email': 'BC25B082@gogem.id',
      'photo': 'assets/images/team/team01.png',
    },
    {
      'name': 'M Mahfudl Awaludin',
      'role': 'UI/UX Designer',
      'email': 'BC25B093@gogem.id',
      'photo': 'assets/images/team/team01.png',
    },
    {
      'name': 'Nur Afdlol Musyafa',
      'role': 'BC25B094',
      'email': 'BC25B094@gogem.id',
      'photo': 'assets/images/team/team01.png',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Tidak dapat membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/logo/gogem-logo.png'), 
              ),
              const SizedBox(height: 16),
              Text(
                'GoGem',
                style: textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Virtual Tour Guide Nusantara',
                style: textTheme.titleSmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'GoGem adalah panduan wisata terintegrasi yang membantu Anda menemukan destinasi populer, kuliner khas, hingga *hidden gem* di seluruh Indonesia, didukung oleh data *real-time* dan teknologi AI (Gemini).',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge!.copyWith(
                  color: colorScheme.onBackground,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Versi Aplikasi: $appVersion',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground.withOpacity(0.8),
                ),
              ),
              const Divider(height: 32),

              Text(
                'Tim Pengembang',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              ...teamMembers.map((member) {
                return _buildTeamMemberTile(
                  context,
                  name: member['name']!,
                  role: member['role']!,
                  email: member['email']!,
                  photoPath: member['photo']!,
                  onTap: () => _launchUrl('mailto:${member['email']}'),
                );
              }).toList(),
              
              const Divider(height: 32),


              Text(
                '© 2024 GoGem - B25-PG005',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET PEMBANTU ---

  // Widget untuk menampilkan profil anggota tim
  Widget _buildTeamMemberTile(
    BuildContext context, {
    required String name,
    required String role,
    required String email,
    required String photoPath,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(photoPath),
        backgroundColor: colorScheme.primary.withOpacity(0.2),
      ),
      title: Text(
        name,
        style: textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        role,
        style: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.email, color: colorScheme.secondary),
        onPressed: onTap,
      ),
      onTap: onTap, // Mengizinkan tap pada seluruh tile untuk kirim email
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  // Widget pembantu untuk elemen List Tile (Kontak & Lisensi)
  Widget _buildAboutTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}