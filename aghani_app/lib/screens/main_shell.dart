import 'package:flutter/material.dart';
import '../widgets/mini_player.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import 'theme_settings_screen.dart';
import 'upload_screen.dart';

/// الهيكل الرئيسي مع شريط التنقل (Alhaykal Alraisi)
class AlhaykalAlraisi extends StatefulWidget {
  const AlhaykalAlraisi({super.key});

  @override
  State<AlhaykalAlraisi> createState() => _HalatAlhaykal();
}

class _HalatAlhaykal extends State<AlhaykalAlraisi> {
  int _alfahras = 0; // الفهرس الحالي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _alfahras,
        children: const [
          ShashatAlraisiya(),
          ShashatAlbahth(),
          ShashatMaktabati(),
          ShashatRafaAlaghani(),
          ShashatTakhsisAlalwan(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MushaghghilMusaghghar(),
          NavigationBar(
            selectedIndex: _alfahras,
            onDestinationSelected: (i) => setState(() => _alfahras = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
              NavigationDestination(icon: Icon(Icons.search), label: 'البحث'),
              NavigationDestination(icon: Icon(Icons.library_music_outlined), selectedIcon: Icon(Icons.library_music), label: 'مكتبتي'),
              NavigationDestination(icon: Icon(Icons.cloud_upload_outlined), selectedIcon: Icon(Icons.cloud_upload), label: 'رفع'),
              NavigationDestination(icon: Icon(Icons.palette_outlined), selectedIcon: Icon(Icons.palette), label: 'الألوان'),
            ],
          ),
        ],
      ),
    );
  }
}
