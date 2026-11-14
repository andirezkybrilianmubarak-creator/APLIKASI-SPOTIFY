import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/sample_data.dart';
import '../models/playlist.dart';
import '../models/song.dart';

/// وضع التكرار
enum WadAltikrar { ghayrMufaal, kullAlqaima, ughniyaWahida }

/// مزوّد الموسيقى (Muzawwid Almusiqa = Music Provider)
class MuzawwidAlmusiqa extends ChangeNotifier {
  final AudioPlayer _mushaghghil = AudioPlayer(); // المشغّل
  final Random _ashwai = Random(); // عشوائي
  final List<StreamSubscription<dynamic>> _ishtirakat = [];

  final List<Ughniya> alaghani = aghaniIftiradiya(); // كل الأغاني
  final Set<String> almufaddala = {}; // معرّفات المفضلة
  final List<String> _almushghalaMuakhkharan = []; // آخر ما شُغّل
  final List<QaimatTashghil> alqawaim = []; // قوائم المستخدم

  List<Ughniya> _qaimatAlintizar = []; // قائمة الانتظار
  int _almawdi3 = -1; // الموضع الحالي

  bool yaamal = false; // هل يعمل الآن؟
  bool yatahammal = false; // هل يحمّل؟
  bool ashwai = false; // عشوائي
  WadAltikrar wadAltikrar = WadAltikrar.ghayrMufaal;
  String? raisalatAlkhata; // رسالة الخطأ

  final ValueNotifier<Duration> almawqi = ValueNotifier(Duration.zero); // الموقع
  Duration almudda = Duration.zero; // المدة

  bool _yuealij = false;

  MuzawwidAlmusiqa() {
    _ishtirakat.add(_mushaghghil.positionStream.listen((p) {
      almawqi.value = p;
    }));
    _ishtirakat.add(_mushaghghil.durationStream.listen((d) {
      almudda = d ?? Duration.zero;
      notifyListeners();
    }));
    _ishtirakat.add(_mushaghghil.playerStateStream.listen((h) {
      yaamal = h.playing;
      yatahammal = h.processingState == ProcessingState.loading ||
          h.processingState == ProcessingState.buffering;
      if (h.processingState == ProcessingState.completed && !_yuealij) {
        _yuealij = true;
        _indihaAlughniya().whenComplete(() => _yuealij = false);
      }
      notifyListeners();
    }));
  }

  // ===== الجلب =====
  Ughniya? get alughniyaAlhaliya =>
      (_almawdi3 >= 0 && _almawdi3 < _qaimatAlintizar.length)
          ? _qaimatAlintizar[_almawdi3]
          : null;

  Ughniya? _ughniyaBilMuarrif(String m) {
    for (final u in alaghani) {
      if (u.muarrif == m) return u;
    }
    return null;
  }

  List<Ughniya> get almushghalaMuakhkharan => _almushghalaMuakhkharan
      .map(_ughniyaBilMuarrif)
      .whereType<Ughniya>()
      .toList();

  List<Ughniya> get alaghaniAlmufaddala =>
      alaghani.where((u) => almufaddala.contains(u.muarrif)).toList();

  List<Ughniya> get alaghaniAlmarfua =>
      alaghani.where((u) => u.rafaaAlmustakhdim).toList();

  List<Ughniya> get alaghaniAljadida {
    final qa = List<Ughniya>.of(alaghani);
    qa.sort((a, b) => b.tarikhAlrafa.compareTo(a.tarikhAlrafa));
    return qa.take(10).toList();
  }

  Map<String, List<Ughniya>> get alaghaniHasabAlnaw {
    final kharita = <String, List<Ughniya>>{};
    for (final u in alaghani) {
      kharita.putIfAbsent(u.alnawAlmusiqi, () => []).add(u);
    }
    return kharita;
  }

  bool halMufaddala(String muarrif) => almufaddala.contains(muarrif);

  List<Ughniya> aghaniAlqaima(QaimatTashghil q) =>
      q.muarrifatAlaghani.map(_ughniyaBilMuarrif).whereType<Ughniya>().toList();

  // ===== التشغيل =====
  Future<void> tashghilAlughniya(Ughniya ughniya, {List<Ughniya>? qaima}) async {
    _qaimatAlintizar = List<Ughniya>.of(qaima ?? alaghani);
    _almawdi3 = _qaimatAlintizar.indexWhere((e) => e.muarrif == ughniya.muarrif);
    if (_almawdi3 < 0) {
      _qaimatAlintizar = [ughniya];
      _almawdi3 = 0;
    }
    await _tahmilWatashghil();
  }

  Future<void> _tahmilWatashghil() async {
    final u = alughniyaAlhaliya;
    if (u == null) return;
    almawqi.value = Duration.zero;
    almudda = Duration.zero;
    raisalatAlkhata = null;
    notifyListeners();
    try {
      final mudda = u.minAlintirnit
          ? await _mushaghghil.setUrl(u.masarAlmilaff)
          : await _mushaghghil.setFilePath(u.masarAlmilaff);
      almudda = mudda ?? Duration.zero;
      unawaited(_mushaghghil.play());
      _sajjilAlmushghal(u.muarrif);
    } catch (_) {
      raisalatAlkhata = 'تعذّر تشغيل هذه الأغنية';
    }
    notifyListeners();
  }

  void _sajjilAlmushghal(String muarrif) {
    _almushghalaMuakhkharan.remove(muarrif);
    _almushghalaMuakhkharan.insert(0, muarrif);
    if (_almushghalaMuakhkharan.length > 12) _almushghalaMuakhkharan.removeLast();
  }

  Future<void> badalAltashghil() async {
    if (alughniyaAlhaliya == null) return;
    if (_mushaghghil.playing) {
      await _mushaghghil.pause();
    } else {
      if (_mushaghghil.processingState == ProcessingState.completed) {
        await _mushaghghil.seek(Duration.zero);
      }
      unawaited(_mushaghghil.play());
    }
  }

  Future<void> _indihaAlughniya() async {
    if (wadAltikrar == WadAltikrar.ughniyaWahida) {
      await _mushaghghil.seek(Duration.zero);
      unawaited(_mushaghghil.play());
    } else {
      await alttali(tilqaiyan: true);
    }
  }

  Future<void> alttali({bool tilqaiyan = false}) async {
    final tul = _qaimatAlintizar.length;
    if (tul == 0) return;
    int tali;
    if (ashwai && tul > 1) {
      do {
        tali = _ashwai.nextInt(tul);
      } while (tali == _almawdi3);
    } else {
      tali = _almawdi3 + 1;
      if (tali >= tul) {
        if (tilqaiyan && wadAltikrar != WadAltikrar.kullAlqaima) {
          await _mushaghghil.pause();
          await _mushaghghil.seek(Duration.zero);
          notifyListeners();
          return;
        }
        tali = 0;
      }
    }
    _almawdi3 = tali;
    await _tahmilWatashghil();
  }

  Future<void> alsabiq() async {
    final tul = _qaimatAlintizar.length;
    if (tul == 0) return;
    if (almawqi.value > const Duration(seconds: 3)) {
      await _mushaghghil.seek(Duration.zero);
      return;
    }
    _almawdi3 = (_almawdi3 - 1 + tul) % tul;
    await _tahmilWatashghil();
  }

  Future<void> intaqilIla(Duration mawqi) => _mushaghghil.seek(mawqi);

  void badalAlashwaiya() {
    ashwai = !ashwai;
    notifyListeners();
  }

  void badalAltikrar() {
    switch (wadAltikrar) {
      case WadAltikrar.ghayrMufaal:
        wadAltikrar = WadAltikrar.kullAlqaima;
        break;
      case WadAltikrar.kullAlqaima:
        wadAltikrar = WadAltikrar.ughniyaWahida;
        break;
      case WadAltikrar.ughniyaWahida:
        wadAltikrar = WadAltikrar.ghayrMufaal;
        break;
    }
    notifyListeners();
  }

  void badalAlmufaddala(String muarrif) {
    if (!almufaddala.add(muarrif)) almufaddala.remove(muarrif);
    notifyListeners();
  }

  // ===== الرفع =====
  Ughniya idafatUghniya({
    required String ismAlughniya,
    required String ismAlfannan,
    required String alnaw,
    required String masarAlmilaff,
    String? masarAlghilaf,
  }) {
    const alwan = [0xFF1DB954, 0xFFE8115B, 0xFF509BF5, 0xFF8D67AB, 0xFFBA5D07];
    final u = Ughniya(
      muarrif: 'marfua_${DateTime.now().microsecondsSinceEpoch}',
      ismAlughniya: ismAlughniya,
      ismAlfannan: ismAlfannan,
      alnawAlmusiqi: alnaw,
      masarAlmilaff: masarAlmilaff,
      masarAlghilaf: masarAlghilaf,
      rafaaAlmustakhdim: true,
      alkalimat: 'لا توجد كلمات لهذه الأغنية بعد.',
      lawnAlghilaf: alwan[_ashwai.nextInt(alwan.length)],
      tarikhAlrafa: DateTime.now(),
    );
    alaghani.insert(0, u);
    notifyListeners();
    return u;
  }

  // ===== قوائم التشغيل =====
  QaimatTashghil inshaaQaimatTashghil(String ism) {
    final q = QaimatTashghil(
      muarrif: 'qaima_${DateTime.now().microsecondsSinceEpoch}',
      ism: ism,
    );
    alqawaim.add(q);
    notifyListeners();
    return q;
  }

  void idafaIlaQaima(QaimatTashghil q, String muarrifAlughniya) {
    if (!q.muarrifatAlaghani.contains(muarrifAlughniya)) {
      q.muarrifatAlaghani.add(muarrifAlughniya);
      notifyListeners();
    }
  }

  void hadhfMinQaima(QaimatTashghil q, String muarrifAlughniya) {
    q.muarrifatAlaghani.remove(muarrifAlughniya);
    notifyListeners();
  }

  void hadhfAlqaima(QaimatTashghil q) {
    alqawaim.remove(q);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final i in _ishtirakat) {
      i.cancel();
    }
    _mushaghghil.dispose();
    almawqi.dispose();
    super.dispose();
  }
}
