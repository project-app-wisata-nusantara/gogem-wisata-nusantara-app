class Destination {
  final String id; // tambahan utk SQLite
  final String nama;
  final String kategori;
  final String kabupatenKota;
  final double rating;
  final String preferensi;
  final String linkLokasi;
  final double latitude;
  final double longitude;
  final String linkGambar;
  final String? deskripsi;

  Destination({
    required this.id,
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
    final generatedId = '${json['nama']}_${json['kabupaten_kota']}'.replaceAll(' ', '_');

    return Destination(
      id: generatedId,
      nama: json['nama'] ?? '',
      kategori: json['kategori'] ?? '',
      kabupatenKota: json['kabupaten_kota'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      preferensi: json['preferensi'] ?? '',
      linkLokasi: json['link_lokasi'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      linkGambar: json['link_gambar'] ?? '',
      deskripsi: json['deskripsi'],
    );
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'],
      nama: map['nama'],
      kategori: map['kategori'],
      kabupatenKota: map['kabupatenKota'],
      rating: map['rating'],
      preferensi: map['preferensi'],
      linkLokasi: map['linkLokasi'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      linkGambar: map['linkGambar'],
      deskripsi: map['deskripsi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'kabupatenKota': kabupatenKota,
      'rating': rating,
      'preferensi': preferensi,
      'linkLokasi': linkLokasi,
      'latitude': latitude,
      'longitude': longitude,
      'linkGambar': linkGambar,
      'deskripsi': deskripsi,
    };
  }

  factory Destination.empty() {
    return Destination(
      id: 'empty',
      nama: '',
      kategori: '',
      kabupatenKota: '',
      rating: 0,
      preferensi: '',
      linkLokasi: '',
      latitude: 0.0,
      longitude: 0.0,
      linkGambar: '',
      deskripsi: '',
    );
  }

}
