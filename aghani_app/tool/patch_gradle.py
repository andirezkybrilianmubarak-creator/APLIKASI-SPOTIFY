#!/usr/bin/env python3
"""Mengatur minSdk = 23 pada android/app/build.gradle(.kts) hasil scaffold Flutter."""
import re, pathlib, sys

ditemukan = False
for nama in ("build.gradle.kts", "build.gradle"):
    p = pathlib.Path("android/app") / nama
    if not p.exists():
        continue
    ditemukan = True
    teks = p.read_text()
    baru = re.sub(r"minSdk(Version)?(\s*=\s*|\s+)flutter\.minSdkVersion", "minSdk = 23", teks)
    p.write_text(baru)
    print(f"[patch] {p}: minSdk -> 23 ({'diubah' if baru != teks else 'tidak ada perubahan'})")
if not ditemukan:
    sys.exit("android/app/build.gradle tidak ditemukan")
