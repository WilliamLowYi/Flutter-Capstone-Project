class Order {
  late String comment, customerId, date, rating, restaurantId, serviceMode, status;
  late Map<dynamic, dynamic> item;

  void fromJson(Map<dynamic, dynamic> map) {
    comment = map['comment'] ?? '';
    customerId = map['customer id'] ?? '';
    date = map['date'] ?? '';
    item = map['item'] ?? {};
    rating = map['rating'] ?? '';
    restaurantId = map['restaurant id'] ?? '';
    serviceMode = map['service mode'] ?? '';
    status = map['status'] ?? '';

  }

  int getTotalItem() {
    int quantity = 0;
    if (item.isEmpty) {
      return quantity;
    } else {
      item.forEach((key, value) {
        quantity += int.parse(value);
      });
      return quantity;
    }
  }
}