import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';

/// Controller for the Balances tab — fetches balance data from Supabase.
class BalancesController extends GetxController {
  final balances = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  // ── Summary values ──
  final youAreOwed = 0.0.obs;
  final youOwe = 0.0.obs;

  double get netBalance => youAreOwed.value - youOwe.value;

  @override
  void onInit() {
    super.onInit();
    fetchBalances();
  }

  /// Fetch balance data from Supabase.
  Future<void> fetchBalances() async {
    isLoading.value = true;
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return;

      final data = await SupabaseService.client
          .from('balances')
          .select()
          .eq('user_id', userId);

      balances.value = List<Map<String, dynamic>>.from(data);

      // Calculate summaries
      double owed = 0;
      double owe = 0;
      for (final b in balances) {
        final amount = (b['amount'] ?? 0).toDouble();
        if (amount > 0) {
          owed += amount;
        } else {
          owe += amount.abs();
        }
      }
      youAreOwed.value = owed;
      youOwe.value = owe;
    } catch (e) {
      // Silently handle — table may not exist yet
      balances.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBalances() async => fetchBalances();
}
