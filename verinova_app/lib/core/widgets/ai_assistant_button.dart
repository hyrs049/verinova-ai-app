import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class AIAssistantButton extends StatelessWidget {
  const AIAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 147, 197, 253),
      onPressed: () => _showWelcomePanel(context),
      child: Image.asset('assets/ai_logo.png', width: 32, height: 32),
    );
  }

  void _showWelcomePanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _WelcomePanel(),
    );
  }
}

class _WelcomePanel extends StatefulWidget {
  @override
  State<_WelcomePanel> createState() => _WelcomePanelState();
}

class _WelcomePanelState extends State<_WelcomePanel> {
  // null = ilk ekran, true = evet, false = hayır
  bool? _answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 320,
      child: _answer == null
          ? _buildWelcome()
          : _answer == false
          ? _buildNoFollowUp()
          : const SizedBox(), // evet → chat'e geçiyor
    );
  }

  // ── İlk ekran ──────────────────────────────────────
  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Merhaba 👋",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Verinizi analiz etmemi ister misiniz?\n"
          "Gelecek ay tahminlerini oluşturabilirim.",
          style: TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiChatScreen()),
                  );
                },
                child: const Text("Evet"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _answer = false),
                child: const Text("Hayır"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Hayır sonrası ───────────────────────────────────
  Widget _buildNoFollowUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Anladım 😊",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Yardımcı olabileceğim bir şey var mı?",
          style: TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiChatScreen()),
                  );
                },
                child: const Text("Evet"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tamam! İhtiyacınız olursa buradayım 🚀"),
                    ),
                  );
                },
                child: const Text("Hayır"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
