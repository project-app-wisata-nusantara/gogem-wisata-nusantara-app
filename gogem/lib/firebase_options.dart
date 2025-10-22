// File: lib/firebase_options.dart
//
// Dibuat manual dari google-services.json & GoogleService-Info.plist
// untuk project: gogem-b5671

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

/// Class konfigurasi Firebase untuk berbagai platform.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase Web belum dikonfigurasi untuk proyek ini.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'Konfigurasi macOS belum tersedia untuk proyek ini.',
        );
      default:
        throw UnsupportedError(
          'Platform ini belum didukung: $defaultTargetPlatform',
        );
    }
  }

  // 🔹 Konfigurasi Android (dari google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3IGFZv8402antXdivpLFwKAtidBWRo4c',
    appId: '1:227480040643:android:cbe394349ee7caef4b5e76',
    messagingSenderId: '227480040643',
    projectId: 'gogem-b5671',
    storageBucket: 'gogem-b5671.firebasestorage.app',
  );

  // 🔹 Konfigurasi iOS (dari GoogleService-Info.plist)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXgBp9z7g73coagFyoPhUVD8KdAxOgPsY',
    appId: '1:227480040643:ios:7632e1a4e6b147a04b5e76',
    messagingSenderId: '227480040643',
    projectId: 'gogem-b5671',
    storageBucket: 'gogem-b5671.firebasestorage.app',
    iosBundleId: 'com.example.gogem',
  );
}
