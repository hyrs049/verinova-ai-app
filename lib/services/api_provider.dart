// services/api_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

// ApiService'i sağlayan provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
