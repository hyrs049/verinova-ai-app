import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class AiService {
  static const bool isWeb = bool.fromEnvironment('dart.library.html');
  static String get aiUrl =>
      isWeb ? 'http://localhost:8001' : 'http://10.0.2.2:8001';
  static String get backendUrl =>
      isWeb ? 'http://localhost:8000' : 'http://172.18.226.14:8000';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  // Fiyat tahmini
  Future<Map<String, dynamic>> getPrediction(
    String coin,
    List<double> prices,
  ) async {
    final res = await http
        .post(
          Uri.parse('$aiUrl/api/ai/prediction'),
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
          Uri.parse('$aiUrl/api/ai/analysis'),
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
          Uri.parse('$aiUrl/api/ai/anomaly'),
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
          Uri.parse('$aiUrl/api/ai/recommend'),
          headers: _headers,
          body: jsonEncode({'portfolio': portfolio}),
        )
        .timeout(const Duration(seconds: 5));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> uploadCSV(
    Uint8List bytes,
    String fileName,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$aiUrl/api/ai/upload'),
    );
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: fileName),
    );
    final response = await request.send().timeout(const Duration(seconds: 15));

    final body = await response.stream.bytesToString();
    return jsonDecode(body);
  }
}
