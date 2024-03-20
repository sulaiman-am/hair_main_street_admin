import 'package:get/get.dart';
import 'package:hair_main_street_admin/models/orderModel.dart';
import 'package:hair_main_street_admin/services/database.dart';

class OrderController extends GetxController {
  RxList<Orders> orders = <Orders>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      print('Fetching orders...');
      Stream<List<Orders>> fetchedOrders = await DataBaseService().getOrders();

      fetchedOrders.listen((List<Orders> data) {
        orders.assignAll(data);
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }
}
