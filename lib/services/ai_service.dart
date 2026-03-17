import 'package:http/http.dart' as http;
import 'dart:convert';

class AiService {
  static const String baseUrl = 'http://192.168.1.104:8001';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  // Fiyat tahmini
  Future<Map<String, dynamic>> getPrediction(
    String coin,
    List<double> prices,
  ) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/api/ai/prediction'),
          headers: _headers,
          body: jsonEncode({'coin': coin, 'prices': prices}),
        )
        .timeout(const Duration(seconds: 5));
    return jsonDecode(res.body);
  }

  // Portföy analizi
  Future<Map<String, dynamic>> analyzePortfolio(
    Map<String, double> portfolio,
  ) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/api/ai/analysis'),
          headers: _headers,
          body: jsonEncode({'portfolio': portfolio}),
        )
        .timeout(const Duration(seconds: 5));
    return jsonDecode(res.body);
  }

  // Anomali tespiti
  Future<Map<String, dynamic>> detectAnomalies(
    List<double> transactions,
  ) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/api/ai/anomaly'),
          headers: _headers,
          body: jsonEncode({'transactions': transactions}),
        )
        .timeout(const Duration(seconds: 5));
    return jsonDecode(res.body);
  }

  // Öneri sistemi
  Future<Map<String, dynamic>> getRecommendations(
    Map<String, double> portfolio,
  ) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl/api/ai/recommend'),
          headers: _headers,
          body: jsonEncode({'portfolio': portfolio}),
        )
        .timeout(const Duration(seconds: 5));
    return jsonDecode(res.body);
  }
}
