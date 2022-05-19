
import 'package:flutter/material.dart';
import 'package:new_customer_ui/utility/dimensions.dart';

import '../../utility/colors.dart';
import '../../widget/popular_food_and_restaurants.dart';
import '../../widget/text_big_style.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Own App Bar
          Container(
            color: ApplicationColors.white,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBigStyle(text: 'Yi\'s Customer App', fontWeight: FontWeight.w600,),
                  Center(
                    child: Container(
                      child: Icon(Icons.search, size: ApplicationDimensions.iconSize24 ,color: Colors.white,),
                      width: ApplicationDimensions.searchIconContainerWidth,
                      height: ApplicationDimensions.searchIconContainerWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ApplicationDimensions.searchIconContainerRadius),
                        color: ApplicationColors.appColor,
                      ),
                    ),
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: ApplicationDimensions.searchIconContainerMarginVertical),
              padding: EdgeInsets.symmetric(horizontal: ApplicationDimensions.searchIconContainerPaddingHorizontal),
            ),
          ),
          // Popular Food Slider
          Expanded(
              child: SingleChildScrollView(
                  child: PopularFoodAndRestaurants()
              )
          ),
        ],
      ),
    );

  }



}
