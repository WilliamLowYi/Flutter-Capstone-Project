import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_customer_ui/utility/dimensions.dart';
import 'package:new_customer_ui/utility/firebase_rtdb_assistant.dart';
import 'package:new_customer_ui/widget/text_big_style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../models/cart_item.dart';
import '../models/restaurant.dart';
import '../routes/route_assistant.dart';
import '../utility/colors.dart';

class CartWidget extends StatelessWidget{
  final CartItem cartItem;

  CartWidget({Key? key,
    required this.cartItem
  }) : super(key: key);

  final RTDBAssistant _rtdbAssistant = RTDBAssistant();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ApplicationDimensions.vertical(5.0),
        horizontal: ApplicationDimensions.horizontal(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(RouteAssistant.getCart(cartItem.restaurantId));
        },
        child: Container(
          decoration: BoxDecoration(
            color: ApplicationColors.white,
            borderRadius: BorderRadius.circular(ApplicationDimensions.radius20)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ApplicationDimensions.horizontal(10.0)),
            child: StreamBuilder<Object>(
              stream: _rtdbAssistant.getFirebaseStream(_rtdbAssistant.pathToRestaurant(cartItem.restaurantId)) as Stream<Object>,
              builder: (context, snapshot) {
                Restaurant restaurant = Restaurant();
                if (snapshot.data != null) {
                  if ((snapshot.data as Event).snapshot.value != null) {
                    restaurant = Restaurant.fromJson((snapshot.data as Event).snapshot.value);
                  }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name, Operation & Total Items
                    Padding(
                      padding: EdgeInsets.only(left: ApplicationDimensions.horizontal(10.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Name
                          TextBigStyle(
                            text: restaurant.name,
                            color: ApplicationColors.blackColor,
                          ),
                          // Closing Time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.access_time
                              ),
                              SizedBox(
                                width: ApplicationDimensions.horizontal(4.0),
                              ),
                              TextSmallStyle(
                                text: restaurant.getOperation(start: false) != '9999' ?
                                  'Closed at ${restaurant.getOperation(start: false)}' :
                                  'Closed',
                                color: restaurant.getOperation(start: false) != '9999' ?
                                  Colors.green: Colors.red,
                                size: ApplicationDimensions.smallTextSize + ApplicationDimensions.vertical(1.0),
                              )
                            ],
                          ),
                          TextSmallStyle(
                            text: 'Total items: ${cartItem.getTotalQuantity().toString()}',
                            size: ApplicationDimensions.smallTextSize + ApplicationDimensions.vertical(1.5),
                          )
                          // Quantity
                        ],
                      ),
                    ),
                    // Restaurant Image
                    Container(
                      child: restaurant.image == ''?
                      const CircularProgressIndicator() :
                      Image(
                        height: ApplicationDimensions.vertical(100.0),
                        image: NetworkImage(
                          restaurant.image
                        ),
                      ),
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

}