import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:new_customer_ui/routes/route_assistant.dart';
import 'package:new_customer_ui/utility/colors.dart';
import 'package:new_customer_ui/utility/dimensions.dart';
import 'package:new_customer_ui/widget/information_card.dart';
import 'package:new_customer_ui/widget/text_big_style.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';
import '../models/restaurant.dart';

class PopularFoodAndRestaurants extends StatefulWidget {
  const PopularFoodAndRestaurants({Key? key}) : super(key: key);

  @override
  State<PopularFoodAndRestaurants> createState() => _PopularFoodAndRestaurantsState();
}

class _PopularFoodAndRestaurantsState extends State<PopularFoodAndRestaurants> {

  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageIndex = 0.0;
  final double _scaleFactor = ApplicationDimensions.scaleFactor;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageIndex = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Popular Food Slider
        Container(
          margin: EdgeInsets.only(top: ApplicationDimensions.popularFoodSliderContainerMarginTop14),
          height: ApplicationDimensions.popularFoodPageViewContainer,
          child: PageView.builder(
            itemCount: ApplicationDimensions.popularFoodItem,
            controller: pageController,
            itemBuilder: (context, index) {
              return StreamBuilder<Object>(
                stream: FirebaseDatabase.instance.reference().child('restaurant').onValue,
                builder: (context, snapshot) {
                  if (snapshot.data != null){
                    Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from((snapshot.data as Event).snapshot.value);
                    String foodId = (data['mcdonald_01']['menu'] as Map).keys.elementAt(index);
                    Food food = Food.fromJson(data['mcdonald_01']['menu'][foodId], foodId);
                    Restaurant restaurant = Restaurant.fromJson(data['mcdonald_01']);

                    return GestureDetector(
                      onTap: (){
                        if (foodId.isNotEmpty){
                          Get.toNamed(RouteAssistant.getFoodDetails(foodId, 'mcdonald_01'));
                        }
                      },
                      child: popularFoodStack(
                        food.image,
                        CardWidget(
                          name: food.name,
                          secondIcons: Icons.fastfood,
                          secondText: food.type,
                          firstIcons: Icons.currency_pound,
                          firstText: double.parse(food.price),
                          category: restaurant.category,
                          takeAway: restaurant.takeAway,
                          dineIn: restaurant.dineIn,
                        ),
                        index
                        ),
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: ApplicationColors.color30,
                      backgroundColor: ApplicationColors.color30,
                    );
                  }
                }
              );
            }),
        ),
        // Dot Indicator
        DotsIndicator(
          dotsCount: ApplicationDimensions.popularFoodItem,
          position: _currentPageIndex,
          decorator: DotsDecorator(
            activeColor: ApplicationColors.appColor,
            spacing: EdgeInsets.symmetric(horizontal: ApplicationDimensions.horizontal(10), vertical: ApplicationDimensions.vertical(10)),
          ),
        ),
        SizedBox(
          height: ApplicationDimensions.sizedBoxHeightBetweenRestaurantTextAndDotIndicator10,
        ),
        // Restaurant Text
        Container(
          margin: EdgeInsets.only(left: ApplicationDimensions.horizontal(25.0), bottom: ApplicationDimensions.vertical(10.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextBigStyle(
                text: 'Restaurant',
                color: Colors.black87,
              ),
              SizedBox(width: ApplicationDimensions.horizontal(10)),
              Container(
                margin: EdgeInsets.only(bottom: ApplicationDimensions.vertical(5.0)),
                child: TextBigStyle(
                  text: '.',
                  color: Colors.black26
                ),
              ),
              SizedBox(width: ApplicationDimensions.horizontal(10)),
              TextSmallStyle(text: 'Popular Rating')
            ],
          ),
        ),
        // List of Restaurants
        StreamBuilder(
          stream: FirebaseDatabase.instance.reference().child('restaurant').onValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<Widget> listOfWidgets = [];
            if (snapshot.data != null) {
              Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from((snapshot.data as Event).snapshot.value);
              data.forEach((key, value) {
                Restaurant restaurant = Restaurant.fromJson(value);
                if (restaurant.isComplete()) {
                  listOfWidgets.add(
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteAssistant.getMenu(key));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ApplicationDimensions
                                  .restaurantContainerMarginHorizontal15,
                              vertical: ApplicationDimensions
                                  .restaurantContainerMarginVertical7),
                          child: Row(
                            children: [
                              // Restaurant Logo
                              Container(
                                width: ApplicationDimensions.restaurantImageContainerWidth,
                                height: ApplicationDimensions.restaurantImageContainerHeight,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ApplicationDimensions
                                            .restaurantImageContainerRadius),
                                    color: Colors.white38,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        restaurant.image.isNotEmpty ? restaurant.image : ''),
                                    )
                                ),
                              ),
                              // Text
                              Expanded(
                                child: Container(
                                    height: ApplicationDimensions.vertical(95.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            ApplicationDimensions.radius20),
                                        bottomRight: Radius.circular(
                                            ApplicationDimensions.radius20),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: ApplicationDimensions.horizontal(
                                              4.0)),
                                      child: CardWidget(
                                        name: restaurant.name.isNotEmpty ? restaurant.name : '',
                                        firstIcons: Icons.timelapse,
                                        secondIcons: Icons.star_rate,
                                        category: restaurant.category.isNotEmpty ? restaurant.category : '',
                                        firstText: restaurant.getOperation(start: true) + ' -- ' +
                                            restaurant.getOperation(start: false),
                                        dineIn: restaurant.dineIn,
                                        secondText: restaurant.rating.isNotEmpty ? restaurant.rating : '',
                                        takeAway: restaurant.takeAway,
                                        containerPaddingHorizontal: ApplicationDimensions.horizontal(10.0),
                                        containerPaddingVertical: ApplicationDimensions.vertical(8.0),
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
                }
              });
            }
            return Column(
              children: listOfWidgets,
            );
          },
        ),

      ]
    );
  }

  Widget popularFoodStack(String image, CardWidget textIconWidget, int index,) {
    Matrix4 matrix = Matrix4.identity();
    // Current
    if ( index == _currentPageIndex.floor() ) {
      var currentScale = 1 - (_currentPageIndex - index) * (1 - _scaleFactor);
      var translation = ApplicationDimensions.popularFoodImageHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, translation, 0);
    } // Right
    else if ( index == _currentPageIndex.floor() + 1){
      var currentScale = _scaleFactor + (_currentPageIndex - index + 1) * (1 - _scaleFactor);
      var translation = ApplicationDimensions.popularFoodImageHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, translation, 0);
    } // Left
    else if ( index == _currentPageIndex.floor() - 1){
      var currentScale = 1 - (_currentPageIndex - index) * (1 - _scaleFactor);
      var translation = ApplicationDimensions.popularFoodImageHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, translation, 0);
    } // Third Appear when sliding
    else {
      var currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)..setTranslationRaw(0, ApplicationDimensions.popularFoodImageHeight * (1 - _scaleFactor)/2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          // Food Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(ApplicationDimensions.radius25),
              color: ApplicationColors.appColor,
            ),
            margin: EdgeInsets.symmetric(horizontal: ApplicationDimensions.horizontal(10.0)),
            height: ApplicationDimensions.popularFoodImageHeight,
          ),
          // Information
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: ApplicationColors.white,
                borderRadius: BorderRadius.circular(ApplicationDimensions.radius25),
                boxShadow: const [
                  BoxShadow(
                      color: ApplicationColors.shadowColor,
                      offset: Offset(0.0, 5.0),
                      blurRadius: 6.0
                  ),
                  BoxShadow(
                    color: ApplicationColors.white,
                    offset: Offset(4.0, 0.0)
                  ),
                  BoxShadow(
                      color: ApplicationColors.white,
                      offset: Offset(-4.0, 0.0)
                  ),
                ]
              ),
              height: ApplicationDimensions.popularFoodTextIconHeight,
              margin: EdgeInsets.only(
                bottom: ApplicationDimensions.popularFoodSliderAlignMarginBottom15,
                right: ApplicationDimensions.popularFoodSliderAlignLeft27,
                left: ApplicationDimensions.popularFoodSliderAlignRight27
              ),
              child: textIconWidget,
            ),
          )
        ],
      ),
    );

  }


}
