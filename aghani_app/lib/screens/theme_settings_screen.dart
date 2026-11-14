import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// شاشة تخصيص الألوان (Shasha Takhsis Alalwan)
class ShashatTakhsisAlalwan extends StatelessWidget {
  const ShashatTakhsisAlalwan({super.key});

  @override
  Widget build(BuildContext context) {
    final z = context.watch<MuzawwidAlmazhar>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('تخصيص الألوان',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text('شدة اللون الأخضر',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: z.shiddatAlakhdar,
            onChanged: z.taghyirAlshidda,
            activeColor: z.lawnAltaakid,
          ),
          const SizedBox(height: 12),
          const Text('درجة ظلام الخلفية',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: z.darajatAlzalam,
            onChanged: z.taghyirAlzalam,
            activeColor: z.lawnAltaakid,
          ),
          const SizedBox(height: 24),
          const Text('معاينة', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: z.lawnAlbitaqaAlthaniya,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          color: z.lawnAltaakid, shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.black, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أغنية تجريبية',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('فنان تجريبي',
                              style: TextStyle(color: z.lawnAlnassAlthanawi)),
                        ],
                      ),
                    ),
                    Icon(Icons.favorite, color: z.lawnAltamyiz),
                  ],
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: 0.4,
                  color: z.lawnAltaakid,
                  backgroundColor: Colors.white12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: const Text('استعادة الألوان الافتراضية'),
            onPressed: z.iadatAltaayin,
          ),
        ],
      ),
    );
  }
}
