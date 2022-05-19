import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_customer_ui/models/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/widget/text_big_style.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../models/restaurant.dart';
import '../pages/history_page.dart';
import '../utility/colors.dart';
import '../utility/dimensions.dart';
import '../utility/firebase_rtdb_assistant.dart';

class HistoryWidget extends StatelessWidget {

  HistoryWidget({Key? key, required this.orderData, required this.orderId}) : super(key: key);
  final Order orderData;
  final String orderId;
  final RTDBAssistant _rtdbAssistant = RTDBAssistant();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ApplicationDimensions.vertical(5.0),
        horizontal: ApplicationDimensions.horizontal(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(orderData, orderId)));
        },
        child: Container(
          decoration: BoxDecoration(
              color: ApplicationColors.white,
              borderRadius: BorderRadius.circular(ApplicationDimensions.radius20)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ApplicationDimensions.horizontal(10.0)),
            child: StreamBuilder<Object>(
                stream: _rtdbAssistant.getFirebaseStream(_rtdbAssistant.pathToRestaurant(orderData.restaurantId)),
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
                            // Status, Total Item, Date
                            TextSmallStyle(
                              text: 'Status: ${orderData.status[0].toUpperCase()}${orderData.status.substring(1)}',
                              size: ApplicationDimensions.smallTextSize + ApplicationDimensions.vertical(1.5),
                            ),
                            TextSmallStyle(
                              text: 'Date: ${orderData.date.substring(0, 10)}',
                              size: ApplicationDimensions.smallTextSize + ApplicationDimensions.vertical(1.5),
                            ),
                            TextSmallStyle(
                              text: 'Items: ${orderData.getTotalItem().toString()}',
                            ),
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
