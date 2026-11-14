import 'package:flutter/material.dart';

/// عنوان قسم (Unwan Qism)
class UnwanQism extends StatelessWidget {
  final String nass;
  const UnwanQism(this.nass, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
      child: Text(
        nass,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
