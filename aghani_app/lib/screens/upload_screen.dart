import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/sample_data.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';

/// شاشة رفع الأغاني (Shasha Rafa Alaghani)
class ShashatRafaAlaghani extends StatefulWidget {
  const ShashatRafaAlaghani({super.key});

  @override
  State<ShashatRafaAlaghani> createState() => _HalatShashatRafa();
}

class _HalatShashatRafa extends State<ShashatRafaAlaghani> {
  final TextEditingController _ismAlughniya = TextEditingController();
  final TextEditingController _ismAlfannan = TextEditingController();
  String _alnaw = qaimatAlanwa.first;
  String? _masarAlsawt; // مسار ملف الصوت
  String? _ismAlmilaff; // اسم الملف
  String? _masarAlghilaf; // مسار الغلاف

  @override
  void dispose() {
    _ismAlughniya.dispose();
    _ismAlfannan.dispose();
    super.dispose();
  }

  // اختيار ملف صوتي
  Future<void> _ikhtiyarAlsawt() async {
    final natija = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );
    if (natija != null && natija.files.single.path != null) {
      setState(() {
        _masarAlsawt = natija.files.single.path;
        _ismAlmilaff = natija.files.single.name;
      });
    }
  }

  // اختيار صورة الغلاف
  Future<void> _ikhtiyarAlghilaf() async {
    final s = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (s != null) setState(() => _masarAlghilaf = s.path);
  }

  void _rafa() {
    final ism = _ismAlughniya.text.trim();
    final fannan = _ismAlfannan.text.trim();
    if (ism.isEmpty || fannan.isEmpty || _masarAlsawt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاسم والفنان واختيار ملف صوتي')),
      );
      return;
    }
    final m = context.read<MuzawwidAlmusiqa>();
    final u = m.idafatUghniya(
      ismAlughniya: ism,
      ismAlfannan: fannan,
      alnaw: _alnaw,
      masarAlmilaff: _masarAlsawt!,
      masarAlghilaf: _masarAlghilaf,
    );
    m.tashghilAlughniya(u, qaima: m.alaghani);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفع الأغنية وبدأ تشغيلها')),
    );
    setState(() {
      _ismAlughniya.clear();
      _ismAlfannan.clear();
      _masarAlsawt = null;
      _ismAlmilaff = null;
      _masarAlghilaf = null;
      _alnaw = qaimatAlanwa.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final z = context.watch<MuzawwidAlmazhar>();
    final hashw = InputDecoration(
      filled: true,
      fillColor: z.lawnAlbitaqaAlthaniya,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('رفع الأغاني',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _ikhtiyarAlghilaf,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: z.lawnAlbitaqaAlthaniya,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: _masarAlghilaf == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 44, color: z.lawnAltaakid),
                        const SizedBox(height: 8),
                        const Text('اختر صورة غلاف الألبوم'),
                      ],
                    )
                  : Image.file(
                      File(_masarAlghilaf!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image)),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ismAlughniya,
            decoration: hashw.copyWith(labelText: 'اسم الأغنية'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ismAlfannan,
            decoration: hashw.copyWith(labelText: 'اسم الفنان'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _alnaw,
            dropdownColor: z.lawnAlbitaqaAlthaniya,
            decoration: hashw.copyWith(labelText: 'النوع الموسيقي'),
            items: [
              for (final n in qaimatAlanwa)
                DropdownMenuItem(value: n, child: Text(n)),
            ],
            onChanged: (v) => setState(() => _alnaw = v ?? _alnaw),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: z.lawnAltaakid,
              side: BorderSide(color: z.lawnAltaakid),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.audio_file),
            label: Text(_ismAlmilaff ?? 'اختيار ملف صوتي (mp3 / wav)'),
            onPressed: _ikhtiyarAlsawt,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: z.lawnAltaakid,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: const Icon(Icons.cloud_upload),
            label: const Text('رفع الأغنية',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: _rafa,
          ),
        ],
      ),
    );
  }
}
