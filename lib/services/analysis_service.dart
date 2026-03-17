import 'dart:math';
import 'ai_service.dart';
import '../models/financial_analysis_model.dart';

class AnalysisService {
  final AiService _aiService = AiService();
  final Random _random = Random();

  Future<FinancialAnalysis> analyzeData() async {
    // Geçmiş fiyatlar — ileride DB'den gelecek
    final List<double> pastPrices = List.generate(
      6,
      (i) => 8000 + _random.nextDouble() * 2000,
    );

    final results = await Future.wait([
      _aiService.getPrediction("BTC", pastPrices),
      _aiService.analyzePortfolio({
        "BTC": 1000.0 + _random.nextDouble() * 8000,
        "ETH": 500.0 + _random.nextDouble() * 4000,
        "USDT": 200.0 + _random.nextDouble() * 2000,
      }),
    ]);

    // AI'dan tahmin al
    final prediction = results[0];

    // AI'dan portföy analizi al
    final analysis = results[1];

    return FinancialAnalysis(
      pastValues: pastPrices,
      predictedNextValue: (prediction['predicted_price'] as num).toDouble(),
      growthRate: prediction['trend'] == 'artış' ? 5.0 : -3.0,
      aiInsight: analysis['insights'][0],
      blockchainHash: "0xAI_CONNECTED",
    );
  }
}
