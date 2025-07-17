import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

// 🔹 Dummy cart items (you can fetch or manage from a provider/state later)
List<CartItem> dummyCartItems = [
  CartItem(
    name: 'Anime T-Shirt',
    price: 999,
    quantity: 1,
    imageUrl: 'https://i.ibb.co/TBKXmSx/anime-tshirt.jpg',
  ),
  CartItem(
    name: 'Smart Watch',
    price: 2499,
    quantity: 2,
    imageUrl: 'https://i.ibb.co/VKBytH6/smart-watch.jpg',
  ),
];

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var item in dummyCartItems) {
      total += item.price * item.quantity;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: dummyCartItems.isEmpty
          ? const Center(child: Text("🛒 Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: dummyCartItems.length,
                    itemBuilder: (context, index) {
                      final item = dummyCartItems[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Text("₹${item.price} × ${item.quantity}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              // Add logic to remove from cart (dummy for now)
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: ₹${total.toStringAsFixed(0)}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ Order placed successfully (COD)"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
