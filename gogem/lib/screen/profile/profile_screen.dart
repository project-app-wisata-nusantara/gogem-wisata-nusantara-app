import 'package:flutter/material.dart';
import 'package:gogem/screen/profile/profile_menu_item.dart';
import 'package:gogem/screen/profile/faq_screen.dart';
import 'package:gogem/screen/profile/about_screen.dart';
import 'package:provider/provider.dart';

import '../../provider/profile/profile_provider.dart';
import '../auth/auth_screen.dart';
import '../../style/theme/gogem_theme.dart';
import 'package:app_settings/app_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProfileProvider>(context, listen: false).loadUserData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final displayName = profileProvider.displayName ?? 'User';
    final email = profileProvider.email ?? 'xxx@gmail.com';
    final photoUrl = profileProvider.photoUrl;

    // --- VARIABEL THEME ADAPTIF ---
    // Menggunakan latar belakang dari tema, bukan hardcode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).colorScheme.onBackground;
    textColor.withOpacity(
      0.7,
    ); // Warna teks sekunder
    // Latar belakang Scaffold sudah diatur di GogemTheme.scaffoldBackgroundColor

    return Scaffold(
      // Hapus hardcode warna background, biarkan Scaffold yang menanganinya
      // backgroundColor: const Color(0xFFFDF6E3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === HEADER ===
            Stack(
              children: [
                // Header image
                // Catatan: Gambar header biasanya perlu diganti dengan gambar yang Dark-Mode friendly
                Image.asset(
                  'assets/images/profile_header.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                // Avatar dan info user
                Positioned(
                  left: 20,
                  bottom: 15,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        // Gunakan warna surface/background yang kontras dengan latar belakang
                        backgroundColor: isDarkMode
                            ? GogemColors.darkGrey
                            : Colors.white,
                        backgroundImage: photoUrl != null
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/images/default_user.png')
                                  as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName.toUpperCase(),
                            style: TextStyle(
                              // Teks pada header image biasanya tetap putih/terang agar kontras
                              color: const Color(0xFF1C1C1C),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              // Teks sekunder juga tetap terang
                              color: Color(0xFF1C1C1C),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === MENU LIST ===
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Pusat Bantuan',
              subtitle: 'Dukungan teknis dan Pertanyaan Umum',
              // Tambahkan penyesuaian warna ikon/teks jika ProfileMenuItem tidak menggunakan tema
              // Misalnya: iconColor: textColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqScreen()),
                );
              },
            ),
            const Divider(
              color: Colors.grey,
            ), // Gunakan Divider yang adaptif (opsional)

            ProfileMenuItem(
              icon: Icons.palette_outlined,
              title: 'Tema',
              subtitle: 'Ubah tema aplikasi',
              onTap: () {
                AppSettings.openAppSettings(type: AppSettingsType.display);
              },
            ),
            const Divider(color: Colors.grey),

            ProfileMenuItem(
              icon: Icons.language_outlined,
              title: 'Bahasa',
              subtitle: 'Ubah bahasa',
              onTap: () {
                AppSettings.openAppSettings(type: AppSettingsType.display);
              },
            ),
            const Divider(color: Colors.grey),

            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'Informasi Aplikasi GoGem',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            const Divider(color: Colors.grey),

            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Keluar',
              subtitle: 'Keluar dari akun ini',
              onTap: () async {
                await profileProvider.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
