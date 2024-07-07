import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/withdrawalRequestController.dart';

class WithdrawalRequestPage extends StatelessWidget {
  final WithdrawalRequestController _withdrawalRequestController =
      Get.put(WithdrawalRequestController());

  WithdrawalRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal Requests'),
      ),
      body: Obx(() {
        if (_withdrawalRequestController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final withdrawalRequests =
            _withdrawalRequestController.withdrawalRequests;
        if (withdrawalRequests.isEmpty) {
          return Center(child: Text('No withdrawal requests found.'));
        }
        return ListView.builder(
          itemCount: withdrawalRequests.length,
          itemBuilder: (context, index) {
            final request = withdrawalRequests[index];
            final requestId = request['id'] as String;
            final status = request['status'] as String? ?? 'pending';

            return ListTile(
              title: Text('Amount: ${request['withdrawal amount']}'),
              subtitle: Text('User ID: ${request['userID']}'),
              trailing: status == 'approved'
                  ? Text('Approved')
                  : ElevatedButton(
                      onPressed: () {
                        _showApprovalConfirmationDialog(
                            context, requestId, request);
                      },
                      child: Text('Approve'),
                    ),
            );
          },
        );
      }),
    );
  }

  void _showApprovalConfirmationDialog(
      BuildContext context, String requestId, Map<String, dynamic> requestMap) {
    final userId = requestMap['userID'] as String? ?? '';
    final amount = requestMap['withdrawal amount'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Approve Withdrawal Request?'),
          content: Text(
              'Are you sure you want to approve this withdrawal request for $amount?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _withdrawalRequestController.approveWithdrawalRequest(
                    userId, requestId);
              },
              child: Text('Approve'),
            ),
          ],
        );
      },
    );
  }
}
