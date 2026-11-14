import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import 'cover.dart';
import 'playlist_helpers.dart';

/// سطر أغنية في قائمة (Satr Alughniya)
class SatrAlughniya extends StatelessWidget {
  final Ughniya ughniya;
  final List<Ughniya> qaima; // قائمة التشغيل المحيطة

  const SatrAlughniya({super.key, required this.ughniya, required this.qaima});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();
    final halia = m.alughniyaAlhaliya?.muarrif == ughniya.muarrif;
    final mufaddala = m.halMufaddala(ughniya.muarrif);
    return ListTile(
      leading: GhilafAlughniya(ughniya: ughniya),
      title: Text(
        ughniya.ismAlughniya,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: halia ? z.lawnAltaakid : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${ughniya.ismAlfannan} • ${ughniya.alnawAlmusiqi}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: z.lawnAlnassAlthanawi),
      ),
      onTap: () => m.tashghilAlughniya(ughniya, qaima: qaima),
      onLongPress: () => eradIdafaIlaQaima(context, ughniya),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              mufaddala ? Icons.favorite : Icons.favorite_border,
              color: mufaddala ? z.lawnAltaakid : z.lawnAlnassAlthanawi,
            ),
            onPressed: () => m.badalAlmufaddala(ughniya.muarrif),
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: () => eradIdafaIlaQaima(context, ughniya),
          ),
        ],
      ),
    );
  }
}
