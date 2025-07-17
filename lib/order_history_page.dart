import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class DummyOrder {
  final List<OrderItem> items;
  final double total;
  final String paymentMethod;
  final DateTime date;

  DummyOrder({
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.date,
  });
}

// 🔹 Dummy orders
List<DummyOrder> dummyOrders = [
  DummyOrder(
    items: [
      OrderItem(
        name: 'Anime T-Shirt',
        price: 999,
        quantity: 1,
        imageUrl: 'https://i.ibb.co/TBKXmSx/anime-tshirt.jpg',
      ),
      OrderItem(
        name: 'Smart Watch',
        price: 2499,
        quantity: 2,
        imageUrl: 'https://i.ibb.co/VKBytH6/smart-watch.jpg',
      ),
    ],
    total: 5997,
    paymentMethod: 'Cash on Delivery',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  DummyOrder(
    items: [
      OrderItem(
        name: 'Blue T-Shirt',
        price: 499,
        quantity: 1,
        imageUrl: 'https://i.ibb.co/hRDCN54/blue-tshirt.jpg',
      ),
    ],
    total: 499,
    paymentMethod: 'Cash on Delivery',
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: dummyOrders.isEmpty
          ? const Center(child: Text("🪪 No orders found."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyOrders.length,
              itemBuilder: (context, index) {
                final order = dummyOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📅 ${DateFormat('dd MMM yyyy, hh:mm a').format(order.date)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...order.items.map((item) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            title: Text(item.name),
                            subtitle: Text("₹${item.price} x ${item.quantity}"),
                          );
                        }),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("💰 Total: ₹${order.total}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("🧾 ${order.paymentMethod}", style: const TextStyle(color: Colors.indigo)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
