import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/playlist_helpers.dart';
import '../widgets/song_tile.dart';

/// شاشة مكتبتي (Shasha Maktabati)
class ShashatMaktabati extends StatelessWidget {
  const ShashatMaktabati({super.key});

  Widget _qaimaFarigha(String nass) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(nass, textAlign: TextAlign.center),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();
    final mufaddala = m.alaghaniAlmufaddala;
    final marfua = m.alaghaniAlmarfua;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('مكتبتي',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'المفضلة'),
                Tab(text: 'أغانيّ المرفوعة'),
                Tab(text: 'قوائم التشغيل'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  mufaddala.isEmpty
                      ? _qaimaFarigha('لم تعجب بأي أغنية بعد.\nاضغط على القلب لإضافتها هنا.')
                      : ListView.builder(
                          itemCount: mufaddala.length,
                          itemBuilder: (c, i) => SatrAlughniya(
                              ughniya: mufaddala[i], qaima: mufaddala),
                        ),
                  marfua.isEmpty
                      ? _qaimaFarigha('لم ترفع أي أغنية بعد.\nاستخدم تبويب "رفع" لإضافة أغانيك.')
                      : ListView.builder(
                          itemCount: marfua.length,
                          itemBuilder: (c, i) =>
                              SatrAlughniya(ughniya: marfua[i], qaima: marfua),
                        ),
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: z.lawnAltaakid,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('إنشاء قائمة تشغيل'),
                        onPressed: () async {
                          final ism = await eradInshaaQaima(context);
                          if (ism != null) m.inshaaQaimatTashghil(ism);
                        },
                      ),
                      const SizedBox(height: 12),
                      if (m.alqawaim.isEmpty)
                        _qaimaFarigha('لا توجد قوائم تشغيل بعد.'),
                      for (final q in m.alqawaim)
                        ListTile(
                          leading: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: z.lawnAlbitaqaAlthaniya,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.queue_music),
                          ),
                          title: Text(q.ism),
                          subtitle: Text('${q.muarrifatAlaghani.length} أغنية'),
                          onTap: () => eradTafasilQaima(context, q),
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
