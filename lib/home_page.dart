import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'dummy_product_uploader.dart';
// ignore: unused_import
import 'product_model.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allProducts = dummyProducts;

    // Unique categories from products
    final categories = ['All', ...{
      for (var p in allProducts) p.category
    }];

    // Filter by category and search
    final filteredProducts = allProducts.where((product) {
      final matchesCategory = selectedCategory == 'All' || product.category == selectedCategory;
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // 🧠 AppBar with branding
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: const Text(
              "🛍️ BlueZone",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🎯 Category Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = cat),
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.grey[300],
                    elevation: 0,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 🧊 Product Grid with animation
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return OpenContainer(
                  transitionDuration: const Duration(milliseconds: 500),
                  closedElevation: 6,
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  closedColor: Colors.white,
                  openBuilder: (_, __) => ProductDetailsPage(product: product),
                  closedBuilder: (_, openContainer) => GestureDetector(
                    onTap: openContainer,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              product.imageUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                                const SizedBox(height: 4),
                                Text("₹${product.price.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
