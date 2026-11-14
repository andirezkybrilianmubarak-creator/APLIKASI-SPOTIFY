/// نموذج قائمة التشغيل (QaimatTashghil = Playlist)
class QaimatTashghil {
  final String muarrif; // المعرّف
  String ism; // اسم القائمة
  final List<String> muarrifatAlaghani; // معرّفات الأغاني

  QaimatTashghil({
    required this.muarrif,
    required this.ism,
    List<String>? muarrifatAlaghani,
  }) : muarrifatAlaghani = muarrifatAlaghani ?? [];
}
