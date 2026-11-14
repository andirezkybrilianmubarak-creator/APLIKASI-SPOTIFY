import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_data.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/song_tile.dart';

/// شاشة البحث (Shasha Albahth)
class ShashatAlbahth extends StatefulWidget {
  const ShashatAlbahth({super.key});

  @override
  State<ShashatAlbahth> createState() => _HalatShashatAlbahth();
}

class _HalatShashatAlbahth extends State<ShashatAlbahth> {
  final TextEditingController _mutahakkim = TextEditingController();
  String _alistifsar = ''; // نص البحث
  String? _alnawAlmukhtar; // النوع المختار

  @override
  void dispose() {
    _mutahakkim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();
    final q = _alistifsar.trim().toLowerCase();

    final natayij = m.alaghani.where((u) {
      final yutabiqAlnass = q.isEmpty ||
          u.ismAlughniya.toLowerCase().contains(q) ||
          u.ismAlfannan.toLowerCase().contains(q);
      final yutabiqAlnaw =
          _alnawAlmukhtar == null || u.alnawAlmusiqi == _alnawAlmukhtar;
      return yutabiqAlnass && yutabiqAlnaw;
    }).toList();

    final yaardAlnatayij = q.isNotEmpty || _alnawAlmukhtar != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('البحث',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _mutahakkim,
              onChanged: (v) => setState(() => _alistifsar = v),
              decoration: InputDecoration(
                hintText: 'ماذا تريد أن تسمع؟',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _alistifsar.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _mutahakkim.clear();
                          setState(() => _alistifsar = '');
                        },
                      ),
                filled: true,
                fillColor: z.lawnAlbitaqaAlthaniya,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_alnawAlmukhtar != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: InputChip(
                  label: Text(_alnawAlmukhtar!),
                  onDeleted: () => setState(() => _alnawAlmukhtar = null),
                ),
              ),
            Expanded(
              child: yaardAlnatayij
                  ? (natayij.isEmpty
                      ? const Center(child: Text('لم يتم العثور على نتائج'))
                      : ListView.builder(
                          itemCount: natayij.length,
                          itemBuilder: (c, i) =>
                              SatrAlughniya(ughniya: natayij[i], qaima: natayij),
                        ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('تصفح الكل',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 1.7,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: [
                              for (final naw in qaimatAlanwa)
                                InkWell(
                                  onTap: () =>
                                      setState(() => _alnawAlmukhtar = naw),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: alwanAlanwa[naw],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(naw,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
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
