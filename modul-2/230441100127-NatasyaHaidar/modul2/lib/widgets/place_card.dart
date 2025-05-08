import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceCard extends StatelessWidget {
  final dynamic image; // Bisa String, File, atau Uint8List
  final String title;
  final String location;
  final VoidCallback onTap;

  const PlaceCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.onTap,
  });

  Widget _buildImage() {
    if (image is Uint8List) {
      return Image.memory(image, height: 60, width: 60, fit: BoxFit.cover);
    } else if (image is String && image.isNotEmpty) {
      return Image.asset(image, height: 60, width: 60, fit: BoxFit.cover);
    } else if (image is File) {
      return Image.file(image, height: 60, width: 60, fit: BoxFit.cover);
    } else {
      return Container(
        height: 60,
        width: 60,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 30, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250, // cukup lebar untuk title & lokasi
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
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
