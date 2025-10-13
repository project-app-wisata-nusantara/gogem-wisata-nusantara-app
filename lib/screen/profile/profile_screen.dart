import 'package:flutter/material.dart';
import 'package:gogem/screen/profile/profile_menu_item.dart';
import 'package:provider/provider.dart';

import '../../provider/profile/profile_provider.dart';
import '../auth/auth_screen.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === HEADER ===
            Stack(
              children: [
                // Header image
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
                        backgroundColor: Colors.white,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
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
              subtitle: 'Lihat alamat email anda',
              onTap: () {},
            ),
            const Divider(),

            ProfileMenuItem(
              icon: Icons.palette_outlined,
              title: 'Tema',
              subtitle: 'Ubah tema aplikasi',
              onTap: () {},
            ),
            const Divider(),

            ProfileMenuItem(
              icon: Icons.language_outlined,
              title: 'Bahasa',
              subtitle: 'Ubah bahasa',
              onTap: () {},
            ),
            const Divider(),

            ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              subtitle: 'Informasi Aplikasi GoGem',
              onTap: () {},
            ),
            const Divider(),

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
