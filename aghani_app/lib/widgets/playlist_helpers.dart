import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import 'cover.dart';

/// نافذة إدخال اسم قائمة جديدة
Future<String?> eradInshaaQaima(BuildContext siyaq) {
  final mutahakkim = TextEditingController();
  return showDialog<String>(
    context: siyaq,
    builder: (c) => AlertDialog(
      title: const Text('إنشاء قائمة تشغيل'),
      content: TextField(
        controller: mutahakkim,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'اسم القائمة'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            final ism = mutahakkim.text.trim();
            Navigator.pop(c, ism.isEmpty ? null : ism);
          },
          child: const Text('إنشاء'),
        ),
      ],
    ),
  );
}

/// نافذة سفلية لإضافة أغنية إلى قائمة
Future<void> eradIdafaIlaQaima(BuildContext siyaq, Ughniya u) {
  return showModalBottomSheet<void>(
    context: siyaq,
    backgroundColor: siyaq.read<MuzawwidAlmazhar>().lawnAlbitaqaAlthaniya,
    builder: (c) {
      return Consumer<MuzawwidAlmusiqa>(
        builder: (c2, m, _) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('إضافة إلى قائمة تشغيل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('قائمة جديدة'),
                onTap: () async {
                  final ism = await eradInshaaQaima(c2);
                  if (ism != null) {
                    final q = m.inshaaQaimatTashghil(ism);
                    m.idafaIlaQaima(q, u.muarrif);
                    if (c2.mounted) Navigator.pop(c2);
                  }
                },
              ),
              for (final q in m.alqawaim)
                ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: Text(q.ism),
                  subtitle: Text('${q.muarrifatAlaghani.length} أغنية'),
                  onTap: () {
                    m.idafaIlaQaima(q, u.muarrif);
                    Navigator.pop(c2);
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// تفاصيل قائمة التشغيل
Future<void> eradTafasilQaima(BuildContext siyaq, QaimatTashghil qaima) {
  return showModalBottomSheet<void>(
    context: siyaq,
    isScrollControlled: true,
    backgroundColor: siyaq.read<MuzawwidAlmazhar>().lawnAlbitaqaAlthaniya,
    builder: (c) {
      return Consumer<MuzawwidAlmusiqa>(
        builder: (c2, m, _) {
          final aghani = m.aghaniAlqaima(qaima);
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (c3, mutahakkimAltamrir) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(qaima.ism,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        tooltip: 'حذف القائمة',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          m.hadhfAlqaima(qaima);
                          Navigator.pop(c2);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: aghani.isEmpty
                      ? const Center(child: Text('القائمة فارغة، أضف أغاني من أي أغنية'))
                      : ListView.builder(
                          controller: mutahakkimAltamrir,
                          itemCount: aghani.length,
                          itemBuilder: (c4, i) {
                            final u = aghani[i];
                            return ListTile(
                              leading: GhilafAlughniya(ughniya: u),
                              title: Text(u.ismAlughniya, maxLines: 1),
                              subtitle: Text(u.ismAlfannan, maxLines: 1),
                              onTap: () => m.tashghilAlughniya(u, qaima: aghani),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => m.hadhfMinQaima(qaima, u.muarrif),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
