class Destination {
  final String nama;
  final String kategori;
  final String kabupatenKota;
  final double rating;
  final String preferensi;
  final String linkLokasi;
  final double latitude;
  final double longitude;
  final String linkGambar;
  final String? deskripsi; // optional, untuk detail tambahan

  // 🔹 Tambahan untuk rekomendasi ML
  double predictedScore; // nilai hasil prediksi dari model
  bool isRecommended; // penanda apakah termasuk top rekomendasi

  Destination({
    required this.nama,
    required this.kategori,
    required this.kabupatenKota,
    required this.rating,
    required this.preferensi,
    required this.linkLokasi,
    required this.latitude,
    required this.longitude,
    required this.linkGambar,
    this.deskripsi,
    this.predictedScore = 0.0,
    this.isRecommended = false,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      kabupatenKota: json['kabupaten_kota'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      preferensi: json['preferensi'] ?? '',
      linkLokasi: json['link_lokasi'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      linkGambar: json['link_gambar'] ?? '',
      deskripsi: json['deskripsi'], // bisa null
      predictedScore: (json['predicted_score'] ?? 0.0).toDouble(),
      isRecommended: json['is_recommended'] ?? false,
    );
  }

  /// Factory untuk object kosong agar tidak menyebabkan crash
  factory Destination.empty() {
    return Destination(
      nama: '',
      kategori: '',
      kabupatenKota: '',
      rating: 0,
      preferensi: '',
      linkLokasi: '',
      latitude: 0,
      longitude: 0,
      linkGambar: '',
      deskripsi: '',
      predictedScore: 0.0,
      isRecommended: false,
    );
  }

  /// Untuk konversi balik ke JSON (kalau nanti kamu mau save/update)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'kategori': kategori,
      'kabupaten_kota': kabupatenKota,
      'rating': rating,
      'preferensi': preferensi,
      'link_lokasi': linkLokasi,
      'latitude': latitude,
      'longitude': longitude,
      'link_gambar': linkGambar,
      'deskripsi': deskripsi,
      'predicted_score': predictedScore,
      'is_recommended': isRecommended,
    };
  }

  // ------------------------------------------------------------
  // 🔹 Bagian tambahan untuk mendukung input ke model ML
  // ------------------------------------------------------------

  /// Normalisasi rating ke skala 0–1
  double get ratingNorm => rating / 5.0;

  /// Encode kategori ke angka (untuk input ke model)
  int get kategoriEnc {
    switch (kategori.toLowerCase()) {
      case 'alam':
        return 0;
      case 'budaya':
        return 1;
      case 'rekreasi':
        return 2;
      case 'umum':
        return 3;
      default:
        return 4;
    }
  }

  /// Encode preferensi ke angka
  int get preferensiEnc {
    switch (preferensi.toLowerCase()) {
      case 'wisata alam':
        return 0;
      case 'wisata budaya':
        return 1;
      case 'wisata rekreasi':
        return 2;
      case 'wisata umum':
        return 3;
      default:
        return 4;
    }
  }

  /// Encode kabupaten/kota ke angka
  int get kabupatenEnc {
    switch (kabupatenKota.toLowerCase()) {
      case 'kabupaten badung':
        return 0;
      case 'kabupaten bangli':
        return 1;
      case 'kabupaten buleleng':
        return 2;
      case 'kabupaten gianyar':
        return 3;
      case 'kabupaten jembrana':
        return 4;
      case 'kabupaten karangasem':
        return 5;
      case 'kabupaten klungkung':
        return 6;
      case 'kabupaten tabanan':
        return 7;
      case 'kota denpasar':
        return 8;
      default:
        return 9;
    }
  }
}
