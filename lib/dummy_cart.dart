import 'product_model.dart';

class DummyCartItem {
  final Product product;
  int quantity;

  DummyCartItem({required this.product, this.quantity = 1});
}

List<DummyCartItem> dummyCartItems = [];

void addToDummyCart(Product product) {
  final index = dummyCartItems.indexWhere((item) => item.product.id == product.id);
  if (index != -1) {
    dummyCartItems[index].quantity += 1;
  } else {
    dummyCartItems.add(DummyCartItem(product: product));
  }
}
