import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ApplicationDimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  static double horizontal(double pixel) { return screenWidth / (screenWidth / pixel); }
  static double vertical(double pixel) { return screenHeight / (screenHeight / pixel); }

  static double popularFoodImageHeight = vertical(200);
  static double popularFoodPageViewContainer = vertical(295);
  static double popularFoodTextIconHeight = vertical(110);

  static double bigTextSize = vertical(20.0);
  static double smallTextSize = vertical(15.0);

  static double iconSize = vertical(20.0);
  static double iconSize24 = vertical(24.0);
  static double iconSize26 = vertical(26.0);

  static double radius25 = vertical(25.0);
  static double radius20 = vertical(20.0);
  static double sizedBoxWidth3 = horizontal(3.0);

  static const FontWeight bigFontWeight = FontWeight.w500;
  static const FontWeight smallFontWeight = FontWeight.w400;

  // Amount of Popular Food Slide
  static const int popularFoodItem = 4;

  // Search Icon Container
  static double searchIconContainerWidth = horizontal(40.0);
  static double searchIconContainerHeight = vertical(40.0);
  static double searchIconContainerRadius = vertical(10.0);
  static double searchIconContainerMarginVertical = vertical(7.5);
  static double searchIconContainerPaddingHorizontal = horizontal(20.0);

  // Scale Factor for Popular Food Slider
  static const double scaleFactor = 0.8;

  static double popularFoodSliderContainerMarginTop14 = vertical(14.0);
  static double popularFoodSliderAlignMarginBottom15 = vertical(15.0);
  static double popularFoodSliderAlignLeft27 = horizontal(27.0);
  static double popularFoodSliderAlignRight27 = horizontal(27.0);

  static double informationCardContainerPaddingVertical15 = vertical(15.0);
  static double informationCardContainerPaddingHorizontal10 = horizontal(10.0);

  static double sizedBoxHeightBetweenRestaurantTextAndDotIndicator10 = vertical(10.0);
  
  static double restaurantContainerMarginHorizontal15 = horizontal(15.0);
  static double restaurantContainerMarginVertical7 = vertical(7.0);
  static double restaurantImageContainerRadius = vertical(20.0);
  static double restaurantImageContainerWidth = horizontal(115.0);
  static double restaurantImageContainerHeight = vertical(115.0);

  static double foodImageSize = vertical(330);
  static double backArrowPosition = horizontal(20.0);
  static double backArrowPositionTop = vertical(65.0);

  static double appIconContainerSize = horizontal(40.0);
  static double appIconSize = horizontal(16.0);

  static double foodDetailsBigTextSize = bigTextSize + vertical(4.0);
  static double foodDetailsSmallTextSize = smallTextSize + vertical(3.0);

}