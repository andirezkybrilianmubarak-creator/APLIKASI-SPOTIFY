import 'package:flutter/material.dart';

/// نموذج الأغنية (Ughniya = Lagu)
class Ughniya {
  final String muarrif; // المعرّف
  final String ismAlughniya; // اسم الأغنية
  final String ismAlfannan; // اسم الفنان
  final String alnawAlmusiqi; // النوع الموسيقي
  final String masarAlmilaff; // مسار ملف الصوت أو الرابط
  final String? masarAlghilaf; // مسار صورة الغلاف
  final bool minAlintirnit; // هل المصدر رابط إنترنت؟
  final bool rafaaAlmustakhdim; // هل رفعها المستخدم؟
  final String alkalimat; // كلمات الأغنية
  final int lawnAlghilaf; // لون الغلاف الافتراضي
  final DateTime tarikhAlrafa; // تاريخ الرفع

  const Ughniya({
    required this.muarrif,
    required this.ismAlughniya,
    required this.ismAlfannan,
    required this.alnawAlmusiqi,
    required this.masarAlmilaff,
    this.masarAlghilaf,
    this.minAlintirnit = false,
    this.rafaaAlmustakhdim = false,
    this.alkalimat = '',
    this.lawnAlghilaf = 0xFF1DB954,
    required this.tarikhAlrafa,
  });

  // اللون كائن Color
  Color get lawn => Color(lawnAlghilaf);
}
