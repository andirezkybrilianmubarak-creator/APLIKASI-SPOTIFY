import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/cover.dart';

String tansiqAlmudda(Duration d) {
  final d2 = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${d.inMinutes}:$d2';
}

/// شاشة المشغّل الكامل (Shasha Almushaghghil Alkamil)
class ShashatAlMushaghghilAlkamil extends StatefulWidget {
  const ShashatAlMushaghghilAlkamil({super.key});

  @override
  State<ShashatAlMushaghghilAlkamil> createState() =>
      _HalatShashatAlMushaghghil();
}

class _HalatShashatAlMushaghghil extends State<ShashatAlMushaghghilAlkamil> {
  double? _qimatAlsahb; // قيمة السحب

  @override
  Widget build(BuildContext context) {
    final m = context.watch<MuzawwidAlmusiqa>();
    final z = context.watch<MuzawwidAlmazhar>();
    final u = m.alughniyaAlhaliya;

    if (u == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('لا توجد أغنية قيد التشغيل')),
      );
    }

    final mufaddala = m.halMufaddala(u.muarrif);
    final hajmAlghilaf = MediaQuery.of(context).size.width - 64;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [u.lawn.withAlpha(150), z.lawnAlkhalfiya],
            stops: const [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text('قيد التشغيل',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                GhilafAlughniya(
                  ughniya: u,
                  hajm: hajmAlghilaf.clamp(200.0, 420.0).toDouble(),
                  nisfQutr: 12,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.ismAlughniya,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(u.ismAlfannan,
                              style: TextStyle(
                                  fontSize: 15, color: z.lawnAlnassAlthanawi)),
                        ],
                      ),
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: Icon(
                        mufaddala ? Icons.favorite : Icons.favorite_border,
                        color: mufaddala ? z.lawnAltaakid : Colors.white70,
                      ),
                      onPressed: () => m.badalAlmufaddala(u.muarrif),
                    ),
                  ],
                ),
                if (m.raisalatAlkhata != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(m.raisalatAlkhata!,
                        style: const TextStyle(color: Colors.redAccent)),
                  ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Duration>(
                  valueListenable: m.almawqi,
                  builder: (c, mawqi, _) {
                    final tul = m.almudda.inMilliseconds.toDouble();
                    final aqsa = tul > 0 ? tul : 1.0;
                    final qima = (_qimatAlsahb ?? mawqi.inMilliseconds.toDouble())
                        .clamp(0.0, aqsa)
                        .toDouble();
                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: aqsa,
                          value: qima,
                          onChanged: tul > 0
                              ? (v) => setState(() => _qimatAlsahb = v)
                              : null,
                          onChangeEnd: (v) {
                            m.intaqilIla(Duration(milliseconds: v.round()));
                            setState(() => _qimatAlsahb = null);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  tansiqAlmudda(Duration(milliseconds: qima.round())),
                                  style: TextStyle(
                                      fontSize: 12, color: z.lawnAlnassAlthanawi)),
                              Text(tansiqAlmudda(m.almudda),
                                  style: TextStyle(
                                      fontSize: 12, color: z.lawnAlnassAlthanawi)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                // في الواجهة العربية (RTL) يظهر أول عنصر في أقصى اليمين
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle,
                          color: m.ashwai ? z.lawnAltaakid : Colors.white70),
                      onPressed: m.badalAlashwaiya,
                    ),
                    IconButton(
                      iconSize: 38,
                      icon: const Icon(Icons.skip_next), // "السابق" يشير لليمين
                      onPressed: m.alsabiq,
                    ),
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: z.lawnAltaakid,
                        shape: BoxShape.circle,
                      ),
                      child: m.yatahammal
                          ? const Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                  color: Colors.black, strokeWidth: 3),
                            )
                          : IconButton(
                              iconSize: 40,
                              color: Colors.black,
                              icon: Icon(
                                  m.yaamal ? Icons.pause : Icons.play_arrow),
                              onPressed: m.badalAltashghil,
                            ),
                    ),
                    IconButton(
                      iconSize: 38,
                      icon: const Icon(Icons.skip_previous), // "التالي" يشير لليسار
                      onPressed: () => m.alttali(),
                    ),
                    IconButton(
                      icon: Icon(
                        m.wadAltikrar == WadAltikrar.ughniyaWahida
                            ? Icons.repeat_one
                            : Icons.repeat,
                        color: m.wadAltikrar == WadAltikrar.ghayrMufaal
                            ? Colors.white70
                            : z.lawnAltaakid,
                      ),
                      onPressed: m.badalAltikrar,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: u.lawn.withAlpha(110),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('كلمات الأغنية',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        u.alkalimat.isEmpty ? 'لا توجد كلمات.' : u.alkalimat,
                        style: const TextStyle(fontSize: 18, height: 1.9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
