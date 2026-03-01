class FinancialAnalysis {
  final List<double> pastValues; // Geçmiş 6 ay veri
  final double predictedNextValue; // Gelecek ay tahmini
  final double growthRate; // % değişim
  final String aiInsight; // AI yorumu
  final String blockchainHash; // Doğrulama hash’i

  FinancialAnalysis({
    required this.pastValues,
    required this.predictedNextValue,
    required this.growthRate,
    required this.aiInsight,
    required this.blockchainHash,
  });
}
