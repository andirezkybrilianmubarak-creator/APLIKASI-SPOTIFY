# ألحان (Aghani) — Flutter Music Streaming & Upload App

Aplikasi streaming & upload musik bergaya Spotify (Dark Mode, RTL, UI Arab).

## Cara pakai
1. Upload seluruh isi folder ini ke ROOT repository GitHub (branch `main`).
2. Buka tab **Actions** → workflow **Build APK** (otomatis jalan saat push, atau klik *Run workflow*).
3. Setelah selesai, unduh artifact **app-release-apk** → `app-release.apk`.

## Catatan Android
- Workflow membuat scaffold `android/` terbaru dari Flutter tanpa menimpa file milik repo
  (`android/app/src/main/AndroidManifest.xml` berisi izin INTERNET, READ_MEDIA_AUDIO, READ_EXTERNAL_STORAGE).
- `tool/patch_gradle.py` mengatur `minSdk = 23`. `compileSdk` mengikuti Flutter stable (>= 34).
- Tanpa keystore, APK release ditandatangani debug key (bisa langsung di-install).

## Catatan penamaan
Dart TIDAK mendukung aksara Arab pada identifier (nama variabel/kelas/fungsi).
Karena itu identifier ditulis dengan transliterasi Arab ke huruf Latin
(mis. `Ughniya` = lagu, `MuzawwidAlmusiqa` = provider musik), sedangkan
seluruh komentar dan teks UI memakai aksara Arab.
