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
      // getHealth yerine assets çekiyoruz artık
      final result = await apiService.getAssets();
      state = AsyncData("${result.length} varlık yüklendi");
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
