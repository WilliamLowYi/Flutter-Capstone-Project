import 'package:new_customer_ui/models/food.dart';
import 'operation.dart';
import 'package:intl/intl.dart';


class Restaurant {
  late String area, category, image, name, rating;
  late bool takeAway, dineIn;
  List<Food>? menu;
  List<Operation>? operation;

  Restaurant({
    this.area = '',
    this.category = '',
    this.image = '',
    this.name = '',
    this.rating = '',
    this.takeAway = false,
    this.dineIn = false,
    this.menu,
    this.operation
  });

  Restaurant.fromJson(Map<dynamic, dynamic> json) {
    area = json['area'];
    category = json['category'];
    image = json['image'];
    name = json['name'];
    rating = json['rating'];
    takeAway = json['service']['take-away'];
    dineIn = json['service']['dine-in'];

    if (json['menu'] != null) {
      menu = <Food> [];
      (json['menu'] as Map).forEach((key, value) {
        menu!.add(Food.fromJson(value, key));
      });
    }

    if (json['operation'] != null) {
      operation = <Operation> [];
      (json['operation'] as Map).forEach((key, value) {
        operation!.add(Operation.fromJson(value, key));
      });
    }

  }

  bool isComplete() {
    return operation != null; // menu != null
  }

  String getOperation({required bool start}) {
    String day = DateFormat('EEEE').format(DateTime.now());
    String time = '9999';
    operation?.forEach((element) {
      time = element.day.toLowerCase() == day.toLowerCase() ? ( start ? element.start : element.end ) : time;
    });
    return time;
  }

  @override
  String toString() {
    return {
      'name': name,
      'area': area,
      'category': category,
      'take-away': takeAway,
      'dine-in': dineIn,
      'image': image,
      'rating': rating,
      'menu': menu?.length,
      'operation': operation?.length,
    }.toString();
  }

  Food getTheFood(String foodId) {
    Food food = Food();
    menu?.forEach((element) {
      if (element.id == foodId) {
        food = element;
      }
    });
    return food;
  }
}