import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../../models/customer_user.dart';
import '../../models/food.dart';
import '../../models/restaurant.dart';
import '../../routes/route_assistant.dart';
import '../../utility/colors.dart';
import '../../utility/dimensions.dart';
import '../../utility/firebase_rtdb_assistant.dart';
import '../../widget/app_icon.dart';
import '../../widget/extendable_text.dart';
import '../../widget/information_card.dart';
import '../../widget/text_big_style.dart';

class FoodDetails extends StatefulWidget {
  String foodId, restaurantId;
  FoodDetails({Key? key,
    required this.restaurantId,
    required this.foodId
  }) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final CustomerUser user = CustomerUser(FirebaseAuth.instance.currentUser);
  int quantity = 1;
  RTDBAssistant rtdbAssistant = RTDBAssistant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors.white,
      body: StreamBuilder(
        stream: rtdbAssistant.getRestaurantStream(widget.restaurantId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            Restaurant restaurant = Restaurant.fromJson((snapshot.data as Event).snapshot.value);
            Food food = restaurant.getTheFood(widget.foodId);
            return Stack(
              children: [
                // Food Image
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.maxFinite,
                    height: ApplicationDimensions.foodImageSize,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(food.image)
                        )
                    ),
                  ),
                ),
                // Icon Button
                Positioned(
                  top: ApplicationDimensions.backArrowPositionTop,
                  left: ApplicationDimensions.backArrowPosition,
                  right: ApplicationDimensions.backArrowPosition,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.maybePop(context); //Get.toNamed(RouteAssistant.getInitial());
                        },
                        child: AppIcon(
                            icon: Icons.arrow_back_ios_new
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteAssistant.getCartList());
                        },
                        child: AppIcon( icon: Icons.shopping_cart_outlined )
                      )
                    ],
                  ),
                ),
                // Restaurant & Food Information
                Positioned(
                  child: Container(
                    //height: ApplicationDimensions.vertical(0),
                    padding: EdgeInsets.only(
                      left: ApplicationDimensions.horizontal(20.0),
                      right: ApplicationDimensions.horizontal(20.0),
                      top: ApplicationDimensions.vertical(10.0),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ApplicationDimensions.radius20),
                        topLeft: Radius.circular(ApplicationDimensions.radius20),
                      ),
                      color: ApplicationColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardWidget(
                          name: food.name,
                          firstIcons: Icons.timelapse,
                          secondIcons: Icons.star_rate,
                          category: restaurant.category,
                          firstText: restaurant.getOperation(start:true) + ' -- ' +
                              restaurant.getOperation(start: false),
                          dineIn: restaurant.dineIn,
                          secondText: restaurant.rating,
                          takeAway: restaurant.takeAway,
                          containerPaddingHorizontal: ApplicationDimensions.horizontal(10.0),
                          containerPaddingVertical: ApplicationDimensions.vertical(11.0),
                          bigTextSize: ApplicationDimensions.foodDetailsBigTextSize,
                          smallTextSize: ApplicationDimensions.foodDetailsSmallTextSize,
                          sizedBoxHeight: ApplicationDimensions.vertical(10.0),
                        ),
                        SizedBox( height: ApplicationDimensions.vertical(20.0),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextBigStyle(
                              text: 'Introduce',
                              color: ApplicationColors.blackColor,
                              size: ApplicationDimensions.foodDetailsBigTextSize,
                            ),
                            Column(
                              children: [
                                TextBigStyle(
                                  text: food.price,
                                  color: ApplicationColors.blackColor,
                                ),
                                TextSmallStyle(
                                    text: 'Base Price'
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: ApplicationDimensions.vertical(15.0),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ExtendableText(
                              text: food.description,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: ApplicationDimensions.foodImageSize - ApplicationDimensions.vertical(30.0),
                ),

              ],
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        },
      ),
      // Price and Quantity
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (quantity != 0) {
                          quantity -= 1;
                        }
                      });
                    },
                    child: Icon(
                      Icons.remove, 
                      color: ApplicationColors.color10, 
                      size: ApplicationDimensions.iconSize26,
                    )
                  ),
                  SizedBox(width: ApplicationDimensions.horizontal(10.0),),
                  TextBigStyle(text: quantity.toString(), color: ApplicationColors.blackColor,),
                  SizedBox(width: ApplicationDimensions.horizontal(10.0),),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (quantity < 50) {
                          quantity += 1;
                        }
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: ApplicationColors.color10,
                      size: ApplicationDimensions.iconSize26,
                    )
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ApplicationDimensions.radius20),
                  color: ApplicationColors.white,
                  border: Border.all(
                      width: 1.5,
                      color: ApplicationColors.color10
                  )
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ApplicationDimensions.horizontal(15.0),
                vertical: ApplicationDimensions.vertical(15.0),
              ),

            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ApplicationDimensions.radius20),
                  color: ApplicationColors.color10
              ),
              child: GestureDetector(
                onTap: () {
                  if (user.isUserLoggedIn()) {
                    FirebaseDatabase.instance.reference().child('basket/${user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}/${widget.foodId}').once().then((value){
                      if (quantity == 0) {
                        FirebaseDatabase.instance.reference().child('basket/${user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}/${widget.foodId}').remove();
                      } else if (value == 0){
                        FirebaseDatabase.instance.reference().child('basket/${user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}').update({
                          widget.foodId : quantity.toString()
                        });
                      } else {
                        FirebaseDatabase.instance.reference().child('basket/${user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}/${widget.foodId}').set(quantity.toString());
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'You have updated your basket.'
                        ),
                      )
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      elevation: 0.5,
                      backgroundColor: ApplicationColors.color10Light,
                      content: const Text(
                        'You haven\'t log in yet.',
                        style: TextStyle(
                          color: ApplicationColors.blackColor
                        ),
                      ),
                      action: SnackBarAction(
                        label: 'Log In',
                        onPressed: () {

                        },
                      )
                    ));
                  }
                },
                child: StreamBuilder(
                  stream: rtdbAssistant.getFoodStream(widget.restaurantId, widget.foodId),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData ) {
                      Food food = Food.fromJson((snapshot.data as Event).snapshot.value, widget.foodId);
                      return TextBigStyle(
                          text: user.isUserLoggedIn() ?
                          '£${(double.parse(food.price) * quantity).toStringAsFixed(2)} | Update Cart' :
                          '£${(double.parse(food.price) * quantity).toStringAsFixed(2)} | Add to Cart',
                          color: ApplicationColors.white
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ApplicationDimensions.horizontal(15.0),
                vertical: ApplicationDimensions.vertical(15.0),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(ApplicationDimensions.radius20 *2),
              topLeft: Radius.circular(ApplicationDimensions.radius20 *2),
            ),
            color: ApplicationColors.color30
        ),
        height: ApplicationDimensions.vertical(100.0),
        padding: EdgeInsets.symmetric(
          horizontal: ApplicationDimensions.horizontal(20.0),
          vertical: ApplicationDimensions.vertical(17.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (user.isUserLoggedIn()) {
      _getAmountInBasket();
    }
  }

  _getAmountInBasket() async {
    await FirebaseDatabase.instance.reference().child(
      rtdbAssistant.pathToBasket(
        'jinglow0787@gmail-com', //FirebaseAuth.instance.currentUser?.email
        restaurantId: widget.restaurantId,
        foodId: widget.foodId,
      )
    ).once().then((snapshot) {
      setState(() {
        quantity = snapshot.value ?? 1;
      });
    });
  }
}
