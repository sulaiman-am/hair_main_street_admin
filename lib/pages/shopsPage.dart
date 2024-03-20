import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_main_street_admin/controllers/shopsController.dart';
import 'package:hair_main_street_admin/models/vendorsModel.dart';
import 'package:hair_main_street_admin/pages/dashboard_page.dart';

// pages/shops_page.dart

class ShopsPage extends StatelessWidget {
  final ShopController shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    shopController.fetchShops();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shops'),
      ),
      body: Obx(
        () {
          if (shopController.shops.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: shopController.shops.length,
              itemBuilder: (context, index) {
                final shop = shopController.shops[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shop Name: ${shop.shopName}'),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Shop ID: ${shop.docID}'),
                                  Text('User ID: ${shop.userID}'),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    _showVerificationDialog(context, shop);
                                  },
                                  child: Text(
                                    'Admin Verification: ${shop.secondVerification == null ? 'Loading...' : shop.secondVerification! ? 'Verified' : 'Not verified'}',
                                    style: TextStyle(
                                      color: shop.secondVerification == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }

  // Method to show a dialog for changing verification status
  void _showVerificationDialog(BuildContext context, Vendors shop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verify this shop'),
          content: Text(
              'Do you want to change the verification status of this shop?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to change verification status
                shopController.changeVerificationStatus(shop);
                Get.back(); // Close the dialog
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
