import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskGauge extends StatelessWidget {
  final double riskScore;

  const RiskGauge({super.key, required this.riskScore});

  Color _getRiskColor(double value) {
    if (value < 40) return Colors.green;
    if (value < 70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          ranges: [
            GaugeRange(startValue: 0, endValue: 40, color: Colors.green),
            GaugeRange(startValue: 40, endValue: 70, color: Colors.orange),
            GaugeRange(startValue: 70, endValue: 100, color: Colors.red),
          ],
          pointers: [
            NeedlePointer(
              value: riskScore,
              needleColor: _getRiskColor(riskScore),
            ),
          ],
          annotations: [
            GaugeAnnotation(
              widget: Text(
                "${riskScore.toStringAsFixed(1)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        ),
      ],
    );
  }
}
