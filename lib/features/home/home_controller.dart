import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:risea/services/api_provider.dart';

final homeControllerProvider = AsyncNotifierProvider<HomeController, String>(
  HomeController.new,
);

class HomeController extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return "Butona bas";
  }

  Future<void> fetchHealth() async {
    state = const AsyncLoading();

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.getHealth();
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
