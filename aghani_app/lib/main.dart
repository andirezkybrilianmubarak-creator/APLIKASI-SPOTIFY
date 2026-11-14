import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/music_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MuzawwidAlmazhar()),
        ChangeNotifierProvider(create: (_) => MuzawwidAlmusiqa()),
      ],
      child: const TatbiqAlaghani(),
    ),
  );
}

/// التطبيق الرئيسي (Tatbiq Alaghani)
class TatbiqAlaghani extends StatelessWidget {
  const TatbiqAlaghani({super.key});

  @override
  Widget build(BuildContext context) {
    final z = context.watch<MuzawwidAlmazhar>();
    return MaterialApp(
      title: 'ألحان',
      debugShowCheckedModeBanner: false,
      theme: z.binaaAlsimma(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // فرض الاتجاه من اليمين إلى اليسار
      builder: (context, ibn) => Directionality(
        textDirection: TextDirection.rtl,
        child: ibn!,
      ),
      home: const AlhaykalAlraisi(),
    );
  }
}
