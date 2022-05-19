class Order{
  String comment = '';
  Map<dynamic, dynamic> foodList = {};
  String rating = '';
  String restaurantId = '';
  String customerEmail = '';
  String serviceMode = '';
  String status = '';

  Order(dynamic orderData){
    orderData = Map<dynamic, dynamic>.from(orderData);
    orderData.forEach((key, value) {
      switch(key) {
        case 'comment': {
          comment = value;
        }
        break;

        case 'customer id': {
          customerEmail = value;
        }
        break;


        case 'item': {
          foodList = value;
        }
        break;

        case 'rating': {
          rating = value;
        }
        break;

        case 'restaurant id': {
          restaurantId = value;
        }
        break;

        case 'service mode': {
          serviceMode = value;
        }
        break;

        case 'status': {
          status = value;
        }
        break;

        default: {
          print('what is in the order: ' + key);
        }
      }
    });
  }


}
