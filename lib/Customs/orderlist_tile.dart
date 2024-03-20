import 'package:flutter/material.dart';

class OrderListTile extends StatelessWidget {
  final String vendorId;
  final String shippingAddress;
  final String orderStatus;
  final String orderDate;
  final String paymentStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  OrderListTile({
    required this.vendorId,
    required this.shippingAddress,
    required this.orderStatus,
    required this.orderDate,
    required this.paymentStatus,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var colorHover = const Color.fromARGB(255, 200, 242, 237);
    return Card(
      child: ListTile(
        dense: true,
        focusColor: colorHover,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.all(5),
        title: Text(
          'Vendor ID: $vendorId',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address: $shippingAddress'),
            Text('Order Status: $orderStatus'),
            Text('Order Date: $orderDate'),
            Text('Payment Status: $paymentStatus'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
