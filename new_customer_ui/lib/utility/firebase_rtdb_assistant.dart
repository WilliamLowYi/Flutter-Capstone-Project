import 'package:firebase_database/firebase_database.dart';
// Real Time Database
class RTDBAssistant {

  String pathToRoot() {
    return 'restaurant';
  }

  String pathToRestaurant(String restaurantId) {
    return pathToRoot() + '/$restaurantId';
  }

  String pathToFood(String restaurantId, String foodId) {
    return pathToRestaurant(restaurantId) + '/menu/$foodId';
  }

  String pathToBasket(String? email, {String restaurantId = "", String foodId = ""}) {
    String path = 'basket/${email.toString().replaceAll('.', '-')}';
    if (restaurantId != "") {
      path += '/' + restaurantId;
    }
    if (restaurantId != "" && foodId != ""){
      path += '/' + foodId;
    }
    print('?' + path);
    return path;
  }

  String pathToOrder() {
    return 'order';
  }

  getFirebaseStream(String path) {
    return FirebaseDatabase.instance.reference().child(path).onValue;
  }

  Stream<dynamic>? getFoodStream(String restaurantId, String foodId) {
    return getFirebaseStream(pathToFood(restaurantId, foodId));
  }

  Stream<dynamic>? getRestaurantStream(String restaurantId) {
    return getFirebaseStream(pathToRestaurant(restaurantId));
  }

  Stream<dynamic>? getBasketStream(String email, {String restaurantId = "", String foodId = ""}) {
    return getFirebaseStream(pathToBasket(email, restaurantId : restaurantId, foodId : foodId));
  }
  
  Stream<dynamic>? getOrderStream()  {
    return getFirebaseStream(pathToOrder());
  }
  
}