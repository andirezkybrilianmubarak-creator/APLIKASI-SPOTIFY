import 'package:flutter/material.dart';
import '../models/song.dart';

/// قائمة الأنواع الموسيقية
const List<String> qaimatAlanwa = [
  'بوب',
  'روك',
  'هيب هوب',
  'كلاسيكي',
  'إلكترونية',
  'جاز',
  'شعبي',
  'هادئ',
];

/// ألوان بطاقات الأنواع
const Map<String, Color> alwanAlanwa = {
  'بوب': Color(0xFFE8115B),
  'روك': Color(0xFFBA5D07),
  'هيب هوب': Color(0xFF8D67AB),
  'كلاسيكي': Color(0xFF477D95),
  'إلكترونية': Color(0xFF1E3264),
  'جاز': Color(0xFFE1118C),
  'شعبي': Color(0xFF148A08),
  'هادئ': Color(0xFF509BF5),
};

const String _kalimatAftiradiya =
    'في الليل أسمع لحنًا بعيدًا\nيحمل لي ذكرى من زمن جميل\nأغمض عيني وأمضي معه\nوالقلب يغني بلا رحيل\n\nيا نغمةً تسكن الروح\nخذيني حيث الأمان\nفي كل لحنٍ حكاية\nوفي كل صوتٍ أمان';

/// أغانٍ افتراضية للعرض (روابط تجريبية عامة)
List<Ughniya> aghaniIftiradiya() {
  final ilan = DateTime.now();
  final bayanat = <List<dynamic>>[
    ['سماء المساء', 'ليلى حسن', 'هادئ', 0xFF509BF5],
    ['طريق الصحراء', 'فرقة الواحة', 'شعبي', 0xFF148A08],
    ['نبض المدينة', 'كريم ناصر', 'إلكترونية', 0xFF1E3264],
    ['حنين', 'سلمى يوسف', 'بوب', 0xFFE8115B],
    ['ليالي الجاز', 'ثلاثي النيل', 'جاز', 0xFFE1118C],
    ['صدى الجبال', 'عمر الفارس', 'روك', 0xFFBA5D07],
  ];
  final natija = <Ughniya>[];
  for (var i = 0; i < bayanat.length; i++) {
    natija.add(Ughniya(
      muarrif: 'iftiradi_${i + 1}',
      ismAlughniya: bayanat[i][0] as String,
      ismAlfannan: bayanat[i][1] as String,
      alnawAlmusiqi: bayanat[i][2] as String,
      masarAlmilaff:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${i + 1}.mp3',
      minAlintirnit: true,
      alkalimat: _kalimatAftiradiya,
      lawnAlghilaf: bayanat[i][3] as int,
      tarikhAlrafa: ilan.subtract(Duration(days: i)),
    ));
  }
  return natija;
}
