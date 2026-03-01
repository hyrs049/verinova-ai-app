import 'dart:math';
import '../models/financial_analysis_model.dart';

class AnalysisService {
  Future<FinancialAnalysis> analyzeData() async {
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();

    List<double> past = List.generate(
      6,
      (index) => 8000 + random.nextDouble() * 4000,
    );

    double lastValue = past.last;
    double predicted = lastValue * (1 + (random.nextDouble() * 0.15));
    double growth = ((predicted - lastValue) / lastValue) * 100;

    return FinancialAnalysis(
      pastValues: past,
      predictedNextValue: predicted,
      growthRate: growth,
      aiInsight: _generateInsight(growth),
      blockchainHash: "0xF${random.nextInt(999999)}A21BC",
    );
  }

  String _generateInsight(double growth) {
    if (growth > 10) {
      return "Tüketim artış trendinde. Önümüzdeki ay maliyet artışı bekleniyor.";
    } else if (growth < 0) {
      return "Tüketim düşüş eğiliminde. Verimlilik artışı gözlemleniyor.";
    } else {
      return "Tüketim stabil seyrediyor. Mevcut strateji sürdürülebilir.";
    }
  }
}
