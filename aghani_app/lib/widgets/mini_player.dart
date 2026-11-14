import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/full_player_screen.dart';
import 'cover.dart';

/// المشغّل المصغّر (Mushaghghil Musaghghar)
class MushaghghilMusaghghar extends StatelessWidget {
  const MushaghghilMusaghghar({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();
    final u = m.alughniyaAlhaliya;
    if (u == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const ShashatAlMushaghghilAlkamil(),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
        decoration: BoxDecoration(
          color: z.lawnAlbitaqaAlthaniya,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  GhilafAlughniya(ughniya: u, hajm: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.ismAlughniya,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(u.ismAlfannan,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: z.lawnAlnassAlthanawi)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      m.halMufaddala(u.muarrif)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: m.halMufaddala(u.muarrif)
                          ? z.lawnAltaakid
                          : Colors.white70,
                    ),
                    onPressed: () => m.badalAlmufaddala(u.muarrif),
                  ),
                  IconButton(
                    icon: Icon(
                      m.yaamal ? Icons.pause : Icons.play_arrow,
                      size: 30,
                    ),
                    onPressed: m.badalAltashghil,
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<Duration>(
              valueListenable: m.almawqi,
              builder: (c, mawqi, _) {
                final kul = m.almudda.inMilliseconds;
                final nisba = kul > 0
                    ? (mawqi.inMilliseconds / kul).clamp(0.0, 1.0)
                    : 0.0;
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8)),
                  child: LinearProgressIndicator(
                    value: nisba,
                    minHeight: 3,
                    color: z.lawnAltaakid,
                    backgroundColor: Colors.white12,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
