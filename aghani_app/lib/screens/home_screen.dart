import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/cover.dart';
import '../widgets/section_title.dart';

/// الشاشة الرئيسية (Shasha Alraisiya)
class ShashatAlraisiya extends StatelessWidget {
  const ShashatAlraisiya({super.key});

  // تحية حسب الوقت
  String _altahiya() {
    final saa = DateTime.now().hour;
    if (saa >= 5 && saa < 12) return 'صباح الخير';
    if (saa >= 12 && saa < 17) return 'طاب يومك';
    if (saa >= 17 && saa < 21) return 'مساء الخير';
    return 'طابت ليلتك';
  }

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();

    var mushghala = m.almushghalaMuakhkharan;
    if (mushghala.isEmpty) mushghala = m.alaghani;
    mushghala = mushghala.take(6).toList();

    final anwa = m.alaghaniHasabAlnaw.entries.toList();
    final jadida = m.alaghaniAljadida;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_altahiya(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const UnwanQism('تم تشغيلها مؤخراً'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final u in mushghala)
                Material(
                  color: z.lawnAlbitaqaAlthaniya,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => m.tashghilAlughniya(u, qaima: m.alaghani),
                    child: Row(
                      children: [
                        GhilafAlughniya(ughniya: u, hajm: 64, nisfQutr: 0),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(u.ismAlughniya,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const UnwanQism('قوائم التشغيل المختارة'),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: anwa.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (c, i) {
                final naw = anwa[i].key;
                final qaima = anwa[i].value;
                return _BitaqaQaima(
                  ism: 'أفضل أغاني $naw',
                  taghtiya: '${qaima.length} أغنية',
                  ughniya: qaima.first,
                  onTap: () => m.tashghilAlughniya(qaima.first, qaima: qaima),
                );
              },
            ),
          ),
          const UnwanQism('أغانٍ جديدة'),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: jadida.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (c, i) {
                final Ughniya u = jadida[i];
                return _BitaqaQaima(
                  ism: u.ismAlughniya,
                  taghtiya: u.ismAlfannan,
                  ughniya: u,
                  onTap: () => m.tashghilAlughniya(u, qaima: jadida),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// بطاقة في الشريط الأفقي
class _BitaqaQaima extends StatelessWidget {
  final String ism;
  final String taghtiya;
  final Ughniya ughniya;
  final VoidCallback onTap;

  const _BitaqaQaima({
    required this.ism,
    required this.taghtiya,
    required this.ughniya,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final z = context.watch<MuzawwidAlmazhar>();
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GhilafAlughniya(ughniya: ughniya, hajm: 140, nisfQutr: 8),
            const SizedBox(height: 8),
            Text(ism,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(taghtiya,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: z.lawnAlnassAlthanawi)),
          ],
        ),
      ),
    );
  }
}
