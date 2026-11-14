import 'dart:io';
import 'package:flutter/material.dart';
import '../models/song.dart';

/// غلاف الأغنية (Ghilaf Alughniya)
class GhilafAlughniya extends StatelessWidget {
  final Ughniya ughniya;
  final double hajm; // الحجم
  final double nisfQutr; // نصف القطر

  const GhilafAlughniya({
    super.key,
    required this.ughniya,
    this.hajm = 56,
    this.nisfQutr = 4,
  });

  Widget _badil() {
    final hsl = HSLColor.fromColor(ughniya.lawn);
    final aghmaq = hsl.withLightness((hsl.lightness * 0.45).clamp(0.05, 1.0)).toColor();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [ughniya.lawn, aghmaq],
        ),
      ),
      child: Center(
        child: Icon(Icons.music_note, color: Colors.white70, size: hajm * 0.45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final masar = ughniya.masarAlghilaf;
    return ClipRRect(
      borderRadius: BorderRadius.circular(nisfQutr),
      child: SizedBox(
        width: hajm,
        height: hajm,
        child: masar != null
            ? Image.file(
                File(masar),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _badil(),
              )
            : _badil(),
      ),
    );
  }
}
