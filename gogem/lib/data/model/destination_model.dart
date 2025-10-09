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
      deskripsi: json['deskripsi'], // bisa null kalau belum ada
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
    };
  }
}
