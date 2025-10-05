// Model untuk tempat wisata sesuai dengan dataset.json
class WisataModel {
  final String nama;
  final String kategori;
  final String kabupatenKota;
  final double rating;
  final String preferensi;
  final String linkLokasi;
  final double latitude;
  final double longitude;
  final String linkGambar;

  WisataModel({
    required this.nama,
    required this.kategori,
    required this.kabupatenKota,
    required this.rating,
    required this.preferensi,
    required this.linkLokasi,
    required this.latitude,
    required this.longitude,
    required this.linkGambar,
  });

  factory WisataModel.fromJson(Map<String, dynamic> json) {
    return WisataModel(
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      kabupatenKota: json['kabupaten_kota'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      preferensi: json['preferensi'] ?? '',
      linkLokasi: json['link_lokasi'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      linkGambar: json['link_gambar'] ?? '',
    );
  }

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
    };
  }

  // Getter untuk backward compatibility
  String get name => nama;
  String get location => kabupatenKota;
  String get imageUrl => linkGambar;

  // Helper methods
  bool get hasValidImage => linkGambar.isNotEmpty && linkGambar != "No Image Available";
  
  bool get isHighRated => rating >= 4.5;
  
  bool get isCulturalSite => kategori.toLowerCase() == 'budaya';
}

// Model untuk detail tempat wisata (untuk detail screen)
class PlaceDetailModel {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final String description;
  final String historyDescription;
  final double latitude;
  final double longitude;

  PlaceDetailModel({
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.historyDescription,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceDetailModel.fromWisataModel(WisataModel wisata) {
    return PlaceDetailModel(
      name: wisata.nama,
      location: wisata.kabupatenKota,
      rating: wisata.rating,
      imageUrl: wisata.linkGambar,
      description: 'Nikmati keindahan ${wisata.nama} yang terletak di ${wisata.kabupatenKota}. '
          'Tempat wisata ${wisata.kategori.toLowerCase()} ini menawarkan pengalaman tak terlupakan '
          'dengan rating ${wisata.rating} dari para pengunjung.',
      historyDescription: 'Sebagai bagian dari kekayaan wisata ${wisata.kabupatenKota}, '
          '${wisata.nama} telah menjadi destinasi favorit wisatawan. '
          'Dengan kategori ${wisata.preferensi}, tempat ini menawarkan daya tarik yang unik dan memukau.',
      latitude: wisata.latitude,
      longitude: wisata.longitude,
    );
  }
}
