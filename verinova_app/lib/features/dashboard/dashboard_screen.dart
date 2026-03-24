import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dashboard_controller.dart';
import '../../core/widgets/ai_assistant_button.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      floatingActionButton: const AIAssistantButton(),
      appBar: AppBar(title: const Text("AI Öngörü Paneli")),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Hata: $e")),
        data: (data) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // 📈 Trend + Tahmin Grafiği
              const Text(
                "Son 6 Ay + Gelecek Ay Tahmini",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      // Geçmiş veri
                      LineChartBarData(
                        spots: List.generate(
                          data.pastValues.length,
                          (index) =>
                              FlSpot(index.toDouble(), data.pastValues[index]),
                        ),
                        isCurved: true,
                        barWidth: 3,
                      ),

                      // Gelecek tahmini (son noktadan devam)
                      LineChartBarData(
                        spots: [
                          FlSpot(
                            (data.pastValues.length - 1).toDouble(),
                            data.pastValues.last,
                          ),
                          FlSpot(
                            data.pastValues.length.toDouble(),
                            data.predictedNextValue,
                          ),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        dashArray: [6, 4],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔮 Gelecek Ay Tahmini Kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gelecek Ay Tahmini",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${data.predictedNextValue.toStringAsFixed(0)} kWh",
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Değişim: %${data.growthRate.toStringAsFixed(1)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🤖 AI İçgörü
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    data.aiInsight,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔐 Blockchain Doğrulama
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Blockchain Doğrulama Hash:\n${data.blockchainHash}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  ref.read(dashboardProvider.notifier).reload();
                },
                child: const Text("Analizi Yenile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
