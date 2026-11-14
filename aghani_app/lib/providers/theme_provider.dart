import 'package:flutter/material.dart';

/// مزوّد المظهر (Muzawwid Almazhar = Theme Provider)
class MuzawwidAlmazhar extends ChangeNotifier {
  // شدة اللون الأخضر (0 إلى 1) والقيمة الافتراضية 0.5 = #1DB954
  double shiddatAlakhdar = 0.5;
  // درجة ظلام الخلفية (0 إلى 1) والقيمة الافتراضية ≈ #121212
  double darajatAlzalam = 0.5714;

  static const Color _alakhdarAlasasi = Color(0xFF1DB954);

  // اللون الأساسي للتمييز
  Color get lawnAltaakid {
    final hsl = HSLColor.fromColor(_alakhdarAlasasi);
    final tashbu = (hsl.saturation * (0.4 + shiddatAlakhdar * 1.2)).clamp(0.0, 1.0);
    final idaa = (hsl.lightness * (0.6 + shiddatAlakhdar * 0.8)).clamp(0.1, 0.8);
    return hsl.withSaturation(tashbu).withLightness(idaa).toColor();
  }

  // لون التمييز الفاتح
  Color get lawnAltamyiz {
    final hsl = HSLColor.fromColor(lawnAltaakid);
    return hsl.withLightness((hsl.lightness + 0.07).clamp(0.0, 0.9)).toColor();
  }

  int get _qimatAlkhalfiya => (42 * (1 - darajatAlzalam)).round();

  Color _ramadi(int zyada) {
    final q = (_qimatAlkhalfiya + zyada).clamp(0, 255);
    return Color.fromARGB(255, q, q, q);
  }

  Color get lawnAlkhalfiya => _ramadi(0); // #121212
  Color get lawnAlbitaqa => _ramadi(6); // #181818
  Color get lawnAlbitaqaAlthaniya => _ramadi(22); // #282828
  Color get lawnAlnassAlasasi => const Color(0xFFFFFFFF);
  Color get lawnAlnassAlthanawi => const Color(0xFFB3B3B3);

  void taghyirAlshidda(double qima) {
    shiddatAlakhdar = qima;
    notifyListeners();
  }

  void taghyirAlzalam(double qima) {
    darajatAlzalam = qima;
    notifyListeners();
  }

  void iadatAltaayin() {
    shiddatAlakhdar = 0.5;
    darajatAlzalam = 0.5714;
    notifyListeners();
  }

  // بناء السمة العامة
  ThemeData binaaAlsimma() {
    final akhdar = lawnAltaakid;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: lawnAlkhalfiya,
      colorScheme: ColorScheme.dark(
        primary: akhdar,
        secondary: lawnAltamyiz,
        surface: lawnAlbitaqa,
        onSurface: lawnAlnassAlasasi,
        onPrimary: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lawnAlkhalfiya,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lawnAlbitaqa,
        indicatorColor: akhdar.withAlpha(60),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, color: Colors.white),
        ),
        iconTheme: WidgetStateProperty.resolveWith((h) {
          return IconThemeData(
            color: h.contains(WidgetState.selected) ? akhdar : lawnAlnassAlthanawi,
          );
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: akhdar,
        thumbColor: Colors.white,
        inactiveTrackColor: Colors.white24,
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: akhdar,
        labelColor: akhdar,
        unselectedLabelColor: lawnAlnassAlthanawi,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: akhdar),
    );
  }
}
