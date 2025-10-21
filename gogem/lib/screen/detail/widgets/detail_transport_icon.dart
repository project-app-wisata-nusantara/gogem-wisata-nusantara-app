import 'package:flutter/material.dart';

class DetailTransportIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const DetailTransportIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(
            icon,
            color: Colors.orange,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.isEmpty ? 'N/A' : label,
          style: TextStyle(
            fontSize: 12,
            color: label.isEmpty ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}