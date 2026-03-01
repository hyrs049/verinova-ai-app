import 'package:flutter/material.dart';

class AIAssistantButton extends StatelessWidget {
  const AIAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 147, 197, 253),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => const _AIAssistantPanel(),
        );
      },
      child: Image.asset('assets/ai_logo.png', width: 32, height: 32),
    );
  }
}

class _AIAssistantPanel extends StatelessWidget {
  const _AIAssistantPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      child: const Text(
        "Merhaba 👋\n\n"
        "Verinizi analiz etmemi ister misiniz?\n"
        "Gelecek ay tahminlerini oluşturabilirim.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
