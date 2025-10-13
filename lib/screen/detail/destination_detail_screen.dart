import 'package:flutter/material.dart';

import '../../data/model/destination_model.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destination.nama)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            destination.linkGambar.startsWith('http')
                ? Image.network(destination.linkGambar, fit: BoxFit.cover)
                : Image.asset(destination.linkGambar, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(destination.kabupatenKota),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(destination.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    destination.deskripsi ??
                        'Belum ada deskripsi untuk destinasi ini.',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
