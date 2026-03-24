import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/financial_analysis_model.dart';
import '../../services/analysis_service.dart';

final analysisServiceProvider = Provider<AnalysisService>((ref) {
  return AnalysisService();
});

final dashboardProvider =
    AsyncNotifierProvider<DashboardController, FinancialAnalysis>(
      DashboardController.new,
    );

class DashboardController extends AsyncNotifier<FinancialAnalysis> {
  @override
  Future<FinancialAnalysis> build() async {
    final service = ref.read(analysisServiceProvider);
    return await service.analyzeData();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      final service = ref.read(analysisServiceProvider);
      final result = await service.analyzeData();
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
