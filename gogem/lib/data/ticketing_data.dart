class TicketPlatform {
  final String name;
  final String url;
  final String description;
  final List<String> features;

  TicketPlatform({
    required this.name,
    required this.url,
    required this.description,
    required this.features,
  });
}

class TicketingData {
  static final List<TicketPlatform> platforms = [
    TicketPlatform(
      name: 'Traveloka',
      url: 'https://www.traveloka.com/id-id/activities',
      description:
          'Platform lengkap untuk booking tiket wisata, hotel, dan transportasi',
      features: [
        'Berbagai pilihan destinasi wisata',
        'Promo dan diskon menarik',
        'Pembayaran mudah',
        'Customer service 24/7',
      ],
    ),
    TicketPlatform(
      name: 'Tiket.com',
      url: 'https://www.tiket.com/attraction',
      description: 'Booking tiket atraksi wisata se-Indonesia dengan mudah',
      features: [
        'Instant confirmation',
        'Harga terjangkau',
        'Bisa reschedule',
        'Cashback dan reward points',
      ],
    ),
    TicketPlatform(
      name: 'Klook',
      url: 'https://www.klook.com/id/',
      description:
          'Platform booking aktivitas dan atraksi wisata internasional dan lokal',
      features: [
        'E-voucher langsung',
        'Refund mudah',
        'Review dari traveler',
        'Best price guarantee',
      ],
    ),
    TicketPlatform(
      name: 'GoWisata',
      url: 'https://gowisata.com/',
      description: 'Platform khusus wisata Indonesia dengan harga terbaik',
      features: [
        'Fokus destinasi lokal',
        'Paket wisata lengkap',
        'Tour guide tersedia',
        'Customizable package',
      ],
    ),
    TicketPlatform(
      name: 'Pegipegi',
      url: 'https://www.pegipegi.com/wisata/',
      description: 'Booking tiket wisata dengan berbagai pilihan pembayaran',
      features: [
        'Cicilan 0%',
        'Promo spesial',
        'Paylater tersedia',
        'Mudah digunakan',
      ],
    ),
    TicketPlatform(
      name: 'Tokopedia Play',
      url: 'https://www.tokopedia.com/play',
      description: 'Belanja tiket wisata di marketplace terpercaya',
      features: [
        'Seller terpercaya',
        'Cashback OVO',
        'Bebas ongkir',
        'Tokopedia Protection',
      ],
    ),
  ];

  static String getRecommendationText() {
    String result =
        'Berikut rekomendasi platform untuk membeli tiket wisata:\n\n';

    for (int i = 0; i < platforms.length; i++) {
      final platform = platforms[i];
      result += '${i + 1}. ${platform.name}\n';
      result += '   ${platform.description}\n';
      result += '   Link: ${platform.url}\n';

      if (i < platforms.length - 1) {
        result += '\n';
      }
    }

    result +=
        '\n💡 Tips: Bandingkan harga di beberapa platform untuk mendapatkan deal terbaik!';

    return result;
  }

  static List<String> getPlatformNames() {
    return platforms.map((p) => p.name).toList();
  }

  static TicketPlatform? getPlatformByName(String name) {
    try {
      return platforms.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
