import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_customer_ui/routes/route_assistant.dart';
import 'package:new_customer_ui/widget/text_big_style.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../models/food.dart';
import '../utility/colors.dart';
import '../utility/dimensions.dart';

class MenuCard extends StatelessWidget {
  final Food food;
  final String restaurantId;
  const MenuCard({Key? key, required this.food, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ApplicationDimensions.vertical(3.0),
        horizontal: ApplicationDimensions.horizontal(7.0),
      ),
      child: GestureDetector(
        onTap: (){
          Get.toNamed(RouteAssistant.getFoodDetails(food.id, restaurantId));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 2.0,
          color: ApplicationColors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: ApplicationDimensions.vertical(8.0)),
            child: ListTile(
              leading: Image(
                height: ApplicationDimensions.vertical(400.0),
                image: NetworkImage(food.image),
              ),
              title: TextBigStyle(
                text: food.name,
                maxLines: 3,
                softWrap: true,
                color: ApplicationColors.blackColor,
              ),
              subtitle: Column(
                children: [
                  Row(
                      children: [
                        TextSmallStyle(
                          text: '£${food.price}',
                          size: ApplicationDimensions.vertical(19.0),
                        )
                      ]
                  ),
                  Row(
                      children: [
                        TextSmallStyle(
                          text: food.type,
                          size: ApplicationDimensions.vertical(17.0 ),
                                
                        )
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
