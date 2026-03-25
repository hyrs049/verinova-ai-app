import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Local test
  static const String backendUrl = 'http://172.18.226.14:8000';
  static const String aiUrl = 'http://172.18.226.50:8001';

  // Token tutmak için
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  // Header oluşturucu
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ─── AUTH ───────────────────────────────────────────

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$backendUrl/api/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$backendUrl/api/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (data['token'] != null) setToken(data['token']);
    return data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/auth/me'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // ─── BLOCKCHAIN ─────────────────────────────────────

  Future<Map<String, dynamic>> getWallet() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/blockchain/wallet'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getTransactions() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/blockchain/transactions'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> transfer(String toAddress, double amount) async {
    final res = await http.post(
      Uri.parse('$backendUrl/api/blockchain/transfer'),
      headers: _headers,
      body: jsonEncode({'to_address': toAddress, 'amount': amount}),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getBalance() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/blockchain/balance'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // ─── VERİ / LİSTELEME ───────────────────────────────

  Future<List<dynamic>> getAssets() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/data/assets'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getPrices() async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/data/prices'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getPriceHistory(String id) async {
    final res = await http.get(
      Uri.parse('$backendUrl/api/data/history/$id'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // ─── AI / ANALİZ ────────────────────────────────────

  Future<Map<String, dynamic>> getAIPrediction(String coin) async {
    final res = await http.get(
      Uri.parse('$aiUrl/api/ai/prediction/$coin'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getPortfolioAnalysis() async {
    final res = await http.get(
      Uri.parse('$aiUrl/api/ai/analysis'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getRecommendation(
    Map<String, dynamic> portfolio,
  ) async {
    final res = await http.post(
      Uri.parse('$aiUrl/api/ai/recommend'),
      headers: _headers,
      body: jsonEncode({'portfolio': portfolio}),
    );
    return jsonDecode(res.body);
  }
}
