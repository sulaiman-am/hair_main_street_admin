import 'package:get/get.dart';
import 'package:hair_main_street_admin/models/withdrawal_requests.dart';
import 'package:hair_main_street_admin/services/database.dart';

class WithdrawalRequestController extends GetxController {
  final DataBaseService _databaseService = DataBaseService();

  var withdrawalRequests = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawalRequests();
  }

  void fetchWithdrawalRequests() {
    _databaseService.getWithdrawalRequests().listen((data) {
      withdrawalRequests.value = data;
    }, onError: (e) {
      Get.snackbar('Error', e.toString());
    });
  }

  Future<void> approveWithdrawalRequest(String userId, String requestId) async {
    isLoading.value = true;
    try {
      await _databaseService.approveWithdrawalRequest(userId, requestId);
      isLoading.value = false;
      Get.snackbar('Success', 'Withdrawal request approved successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to approve request: $e');
    }
  }
}
