import 'package:flutter/material.dart';
import 'package:new_customer_ui/widget/text_big_style.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../utility/colors.dart';
import '../utility/dimensions.dart';

class CardWidget extends StatelessWidget {
  final String name, category;
  final bool dineIn, takeAway;
  final dynamic firstText, secondText;
  final IconData firstIcons, secondIcons;
  final double smallTextSize, bigTextSize,
      containerPaddingVertical, containerPaddingHorizontal, sizedBoxHeight;
  const CardWidget({Key? key,
    required this.name,
    required this.category,
    required this.dineIn,
    required this.takeAway,
    required this.firstText,
    required this.secondText,
    required this.firstIcons,
    required this.secondIcons,
    this.smallTextSize = 0,
    this.bigTextSize = 0,
    this.containerPaddingVertical = 0,
    this.containerPaddingHorizontal = 0,
    this.sizedBoxHeight = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Food Name
          TextBigStyle(
            text: name,
            color: ApplicationColors.blackColor,
            size: bigTextSize,
          ),
          SizedBox(
            height: sizedBoxHeight == 0 ? ApplicationDimensions.vertical(5.0) : sizedBoxHeight,),
          // Rating & Price
          Row(
            children: [
              Row(
                children: [
                  Icon(firstIcons, size: ApplicationDimensions.iconSize),
                  SizedBox( width: ApplicationDimensions.sizedBoxWidth3 - ApplicationDimensions.horizontal(2.0)),
                  TextSmallStyle(
                      text: firstText.toString(),
                      size: smallTextSize
                  ),
                ],
              ),
              SizedBox(width: ApplicationDimensions.horizontal(15.0)),
              Icon(Icons.restaurant_menu, size: ApplicationDimensions.iconSize, color: ApplicationColors.blackColor,),
              SizedBox(width: ApplicationDimensions.sizedBoxWidth3),
              Flexible(
                child: TextSmallStyle(
                    text: category,
                    size: smallTextSize
                ),
              ),
            ],
          ),
          SizedBox(height: sizedBoxHeight == 0 ? ApplicationDimensions.vertical(5.0) : sizedBoxHeight,),
          // Category & Service
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(secondIcons, size: ApplicationDimensions.iconSize, color: ApplicationColors.neutralColor),
                  SizedBox( width: ApplicationDimensions.sizedBoxWidth3),
                  TextSmallStyle(
                    text: secondText,
                    size: smallTextSize
                  ),
                ],
              ),
              Row(
                children: [
                  dineIn ? Icon(Icons.check_circle, size: ApplicationDimensions.iconSize, color: ApplicationColors.trueColor,) : Icon(Icons.cancel, size: ApplicationDimensions.iconSize, color: ApplicationColors.falseColor,),
                  SizedBox(width: ApplicationDimensions.sizedBoxWidth3),
                  TextSmallStyle(
                    text: 'Dine In',
                    size: smallTextSize
                  ),
                ],
              ),
              Row(
                children: [
                  takeAway ? Icon(Icons.check_circle, size: ApplicationDimensions.iconSize, color: ApplicationColors.trueColor,) : Icon(Icons.cancel, size: ApplicationDimensions.iconSize, color: ApplicationColors.falseColor,),
                  SizedBox(width: ApplicationDimensions.sizedBoxWidth3),
                  TextSmallStyle(
                    text: 'Take Away',
                    size: smallTextSize
                  ),
                ],
              ),
            ],
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: EdgeInsets.symmetric(
        vertical: containerPaddingVertical == 0 ? ApplicationDimensions.informationCardContainerPaddingVertical15 : containerPaddingVertical,
        horizontal: containerPaddingHorizontal == 0? ApplicationDimensions.informationCardContainerPaddingHorizontal10 : containerPaddingHorizontal
      ),
    );
  }
}



