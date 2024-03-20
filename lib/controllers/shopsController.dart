import 'package:get/get.dart';
import 'package:hair_main_street_admin/models/vendorsModel.dart';

import 'package:hair_main_street_admin/services/database.dart';

// controllers/shop_controller.dart

class ShopController extends GetxController {
  RxList<Vendors> shops = <Vendors>[].obs;
  Rx<Vendors?> selectedShop = Rx<Vendors?>(null);

  void selectShop(Vendors shop) {
    selectedShop.value = shop;
  }

  Future<void> fetchShops() async {
    try {
      print('Fetching shops...');
      Stream<List<Vendors>> fetchedShops = await DataBaseService().getShops();

      fetchedShops.listen((List<Vendors> data) {
        shops.assignAll(data);
      });
    } catch (e) {
      print("Error fetching shops: $e");
    }
  }

  Future<void> changeVerificationStatus(Vendors shop) async {
    try {
      // Change the verification status logic here
      shop.secondVerification = !(shop.secondVerification ?? false);

      // Update the shop in the database
      await DataBaseService().updateShop(shop);

      // Optionally, you can also update the local state if needed
      shops[shops.indexWhere((element) => element.docID == shop.docID)] = shop;
    } catch (e) {
      print("Error changing verification status: $e");
    }
  }
}
