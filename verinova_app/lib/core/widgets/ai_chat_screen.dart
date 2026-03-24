import 'package:flutter/material.dart';
import '../../services/ai_service.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiService _aiService = AiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Karşılama mesajı
    _messages.add({
      "role": "ai",
      "text":
          "Merhaba! 👋 Size nasıl yardımcı olabilirim?\n\n"
          "Şunları sorabilirsiniz:\n"
          "• BTC fiyat tahmini\n"
          "• Portföy analizi\n"
          "• Anomali tespiti\n"
          "• Genel kripto soruları",
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final response = await _getAIResponse(text);

    setState(() {
      _messages.add({"role": "ai", "text": response});
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Future<String> _getAIResponse(String message) async {
    final msg = message.toLowerCase();

    try {
      // Fiyat tahmini
      if (msg.contains("tahmin") ||
          msg.contains("fiyat") ||
          msg.contains("btc") ||
          msg.contains("bitcoin")) {
        final coin = msg.contains("eth") ? "ETH" : "BTC";
        final result = await _aiService.getPrediction(coin, [
          8000,
          8500,
          9000,
          8800,
          9200,
          9500,
        ]);
        return "📈 $coin Fiyat Tahmini:\n\n"
            "Tahmini fiyat: \$${result['predicted_price']}\n"
            "Trend: ${result['trend']}\n"
            "Değişim: %${result['change_percent']}\n"
            "Güven skoru: %${((result['confidence'] as num) * 100).toStringAsFixed(0)}";
      }

      // Portföy analizi
      if (msg.contains("portföy") ||
          msg.contains("analiz") ||
          msg.contains("dağılım")) {
        final result = await _aiService.analyzePortfolio({
          "BTC": 5000.0,
          "ETH": 3000.0,
          "USDT": 2000.0,
        });
        final insights = (result['insights'] as List).join("\n• ");
        return "📊 Portföy Analizi:\n\n"
            "Risk seviyesi: ${result['risk_level']}\n\n"
            "Değerlendirme:\n• $insights";
      }

      // Anomali tespiti
      if (msg.contains("anomali") ||
          msg.contains("şüpheli") ||
          msg.contains("anormal")) {
        final result = await _aiService.detectAnomalies([
          1000,
          1200,
          950,
          8500,
          1100,
          980,
          1050,
          12000,
          1000,
        ]);
        final count = result['anomaly_count'];
        return "🔍 Anomali Tespiti:\n\n"
            "Toplam işlem: ${result['total_transactions']}\n"
            "Şüpheli işlem: $count\n\n"
            "${count > 0 ? '⚠️ Dikkat: $count adet anormal işlem tespit edildi!' : '✅ Anormal işlem tespit edilmedi.'}";
      }

      // Öneri
      if (msg.contains("öneri") ||
          msg.contains("ne yapmalı") ||
          msg.contains("tavsiye")) {
        final result = await _aiService.getRecommendations({
          "BTC": 5000.0,
          "ETH": 3000.0,
          "USDT": 2000.0,
        });
        final recs = (result['recommendations'] as List)
            .map(
              (r) =>
                  "${r['coin']}: ${r['action'].toUpperCase()} — ${r['reason']}",
            )
            .join("\n");
        return "💡 Portföy Önerileri:\n\n$recs";
      }

      // Genel kripto soruları
      if (msg.contains("nedir") || msg.contains("ne")) {
        if (msg.contains("blockchain")) {
          return "🔗 Blockchain, verilerin değiştirilemez bloklar halinde zincir şeklinde tutulduğu dağıtık bir kayıt sistemidir. Her blok önceki bloğun hash'ini içerir, bu yüzden güvenlidir.";
        }
        if (msg.contains("bitcoin") || msg.contains("btc")) {
          return "₿ Bitcoin, 2009'da Satoshi Nakamoto tarafından yaratılan ilk ve en büyük kripto paradır. Merkezi olmayan yapısıyla bankasız transfer imkânı sunar.";
        }
        if (msg.contains("ethereum") || msg.contains("eth")) {
          return "⟠ Ethereum, akıllı sözleşmeleri destekleyen bir blockchain platformudur. ETH onun yerel para birimidir.";
        }
      }

      // Varsayılan yanıt
      return "🤖 Şu konularda yardımcı olabilirim:\n\n"
          "• 'BTC fiyat tahmini' — fiyat tahmini\n"
          "• 'Portföy analizi' — portföyünüzü analiz edin\n"
          "• 'Anomali tespiti' — şüpheli işlemleri bulun\n"
          "• 'Öneri ver' — portföy önerisi alın\n"
          "• 'Bitcoin nedir' — kripto bilgisi";
    } catch (e) {
      return "⚠️ Bağlantı hatası. AI servisi çalışıyor mu kontrol edin.";
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Asistan"),
        backgroundColor: const Color.fromARGB(255, 147, 197, 253),
      ),
      body: Column(
        children: [
          // Mesajlar
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildMessage(msg["role"]!, msg["text"]!);
              },
            ),
          ),

          // Hızlı sorular
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children:
                  [
                        "BTC tahmini",
                        "Portföy analizi",
                        "Anomali tespiti",
                        "Öneri ver",
                      ]
                      .map(
                        (q) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(q),
                            onPressed: () => _sendMessage(q),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Mesajınızı yazın...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String role, String text) {
    final isAI = role == "ai";
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isAI ? const Color.fromARGB(255, 220, 235, 255) : Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAI ? Colors.black87 : Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 220, 235, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text("AI yazıyor... ⏳"),
      ),
    );
  }
}
