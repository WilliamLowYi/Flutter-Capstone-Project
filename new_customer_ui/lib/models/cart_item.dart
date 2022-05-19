import 'package:firebase_database/firebase_database.dart';

class CartItem {
  late String restaurantId;
  late Map<dynamic, dynamic> foodMap;
  late double totalPrice;


  CartItem(this.restaurantId, this.foodMap);

  void setFoodPrice() async {
    foodMap.forEach((key, quantity) async {
      await FirebaseDatabase.instance.reference().child('restaurant/$restaurantId/menu/$key/price').once().then((snapshot){
        totalPrice += (int.parse(quantity) * double.parse(snapshot.value));
      });
    });

  }
  int getTotalQuantity() {
    var items = 0;
    foodMap.forEach((key, value) {
      items += int.parse(value);
    });
    return items;
  }

  double getTotalPrice() {
    if (totalPrice == 0.0) {
      setFoodPrice();
    }
    return totalPrice;
  }

  int getAmountOfItems() {
    return foodMap.length;
  }

  List<Map> toListOfMap() {
    List<Map> list = [];
    foodMap.forEach((key, value) {
      list.add({key : value});
    });
    return list;
  }
}