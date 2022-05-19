import 'package:get/get.dart';
import 'package:new_customer_ui/pages/food/food_details.dart';
import 'package:new_customer_ui/pages/all_history.dart';
import 'package:new_customer_ui/pages/menu.dart';

import '../pages/cart/cart_page.dart';
import '../pages/home/home.dart';

class RouteAssistant {
  static const String initial = '/';
  static const String foodDetails = '/food-details';
  static const String menu = '/menu';
  static const String cartList = '/cart-list';
  static const String cart = '/cart';
  static const String history = '/history';

  static String getInitial() => initial;
  static String getFoodDetails(String foodId, String restaurantId) => '$foodDetails?foodId=$foodId&restaurantId=$restaurantId';
  static String getMenu(String restaurantId) => '$menu?restaurantId=$restaurantId';
  static String getCartList() => cartList;
  static String getCart(String restaurantId) => 'cart?restaurantId=$restaurantId';
  static String getHistory() => history;

  static List<GetPage> pagesRoute = [
    GetPage(
      name: initial,
      page: () => Home(selectedIndexWidget: 0,),
      transition: Transition.upToDown
    ),
    GetPage(
      name: foodDetails,
      page: () {
        String foodId, restaurantId;
        foodId = Get.parameters['foodId']!;
        restaurantId = Get.parameters['restaurantId']!;
        return FoodDetails(foodId: foodId, restaurantId: restaurantId,);
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: menu,
      page: () {
        return MenuPage(restaurantId: Get.parameters['restaurantId']!,);
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: cartList,
      page: () => Home(selectedIndexWidget: 1,),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: cart,
      page: () {
        return CartPage(restaurantId: Get.parameters['restaurantId']!);
      },
      transition: Transition.downToUp
    ),
    GetPage(
      name: history,
      page: () => Home(selectedIndexWidget: 2,),
      transition: Transition.downToUp
    )
  ];
}