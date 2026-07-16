import 'package:mini_shop_app/models/order.dart';
import 'package:mini_shop_app/widgets/cart_item.dart';

class Orders {
  List<Order> orders = [];

  void addOrder(List<CartItem> cardProducts, double total) {
    orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cardProducts,
        dateTime: DateTime.now(),
      ),
    );
  }
}
