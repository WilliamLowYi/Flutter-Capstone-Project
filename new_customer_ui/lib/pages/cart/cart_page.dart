import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_customer_ui/models/cart_item.dart';
import 'package:new_customer_ui/models/customer_user.dart';
import 'package:new_customer_ui/utility/firebase_rtdb_assistant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../models/food.dart';
import '../../routes/route_assistant.dart';
import '../../utility/colors.dart';
import '../../utility/dimensions.dart';
import '../../widget/text_big_style.dart';

class CartPage extends StatefulWidget {
  final String restaurantId;
  const CartPage({Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState(){
    super.initState();
  }

  final CustomerUser _user = CustomerUser(FirebaseAuth.instance.currentUser);
  final RTDBAssistant _rtdbAssistant = RTDBAssistant();
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
      stream: _rtdbAssistant.getBasketStream(_user.getUserEmail(), restaurantId: widget.restaurantId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)  {
        if (snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {
          CartItem cartItem = CartItem(widget.restaurantId, (snapshot.data as Event).snapshot.value);
          return Scaffold(
              backgroundColor: ApplicationColors.color30,
              appBar: AppBar(
                leadingWidth: 30.0,
                title: Center(
                  child: StreamBuilder(
                    stream: _rtdbAssistant.getFirebaseStream('${_rtdbAssistant.pathToRestaurant(widget.restaurantId)}/name'),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return Text(
                        snapshot.hasData && (snapshot.data as Event).snapshot.value != null ?
                        (snapshot.data as Event).snapshot.value : 'Cart',
                      );
                    },
                  ),
                ),
              ),
              body: SafeArea(
                child: snapshot.hasData ?
                ListView.builder(
                  itemCount: cartItem.getAmountOfItems(),
                  itemBuilder: (BuildContext context, int index) {
                    return StreamBuilder( // Food Details
                      stream: _rtdbAssistant.getFoodStream(widget.restaurantId, cartItem.foodMap.keys.elementAt(index)),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData && (snapshot.data as Event).snapshot.exists) {
                          Food food = Food.fromJson((snapshot.data as Event).snapshot.value, cartItem.foodMap.keys.elementAt(index));
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Image(
                                    image: NetworkImage(
                                      food.image,
                                    ),
                                  ),
                                  title: TextBigStyle(
                                    text: food.name,
                                    color: ApplicationColors.blackColor,
                                  ),
                                  subtitle: TextSmallStyle( // Price * Quantity in the basket
                                    text: '£${(double.parse(food.price) * int.parse(cartItem.foodMap[cartItem.foodMap.keys.elementAt(index)])).toString()}',
                                  ),
                                ),
                                ],
                            ),
                            decoration: BoxDecoration(
                              color: ApplicationColors.white,
                            ) ,
                          );

                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ) :
                Center(
                  child: TextSmallStyle(
                      text: 'It\'s empty now'
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                child: StreamBuilder(
                  stream: _rtdbAssistant.getFirebaseStream('restaurant/${widget.restaurantId}/menu'),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    double totalPrice = 0;
                    if (snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {
                      List<Food> foodList = [];
                      ((snapshot.data as Event).snapshot.value as Map).forEach((key, value) {
                        foodList.add(Food.fromJson(value, key));
                      });
                      for (var element in foodList) {
                        cartItem.foodMap.forEach((key, value) {
                          if (element.id.toString() == key.toString()) {
                            totalPrice += (double.parse(element.price) * double.parse(value) );
                          }
                        });
                      }

                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ApplicationDimensions.radius20),
                          ),
                          child: TextBigStyle(
                              text:
                              'Total: ${totalPrice.toStringAsFixed(2)}',
                              color: ApplicationColors.textColor
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
                              if (totalPrice > 0.0) {
                                makePayment(totalPrice);
                              } else {
                                print(totalPrice);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment Unsuccessful'),
                                    )
                                );
                              }
                            },
                            child: TextBigStyle(
                                text: 'Place Order',
                                color: ApplicationColors.white
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ApplicationDimensions.horizontal(15.0),
                            vertical: ApplicationDimensions.vertical(15.0),
                          ),
                        )
                      ],
                    );
                  },
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(ApplicationDimensions.radius20 *2),
                      topLeft: Radius.circular(ApplicationDimensions.radius20 *2),
                    ),
                    color: ApplicationColors.color60
                ),
                height: ApplicationDimensions.vertical(80.0),
                padding: EdgeInsets.symmetric(
                  horizontal: ApplicationDimensions.horizontal(20.0),
                  vertical: ApplicationDimensions.vertical(5.0),
                ),
              )
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> makePayment(double totalPrice) async{
    final url = Uri.parse('https://us-central1-restaurant-app-9c812.cloudfunctions.net/stripePayment');

    final response = await http.post(
        url,
        body: {
          'amount': '${totalPrice * 100}'
        }
    );

    paymentIntentData = json.decode(response.body);

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'UK',
            merchantDisplayName: 'Yi Jing'
        )
    );

    setState(() {

    });

    displayPaymentSheet();
  }

  Future<void> displayPaymentSheet() async {
    try{
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIntentData!['paymentIntent'],
              confirmPayment: true
          )
      );
      setState(() {
        paymentIntentData = null;
      });
      Get.toNamed(RouteAssistant.getHistory());
      await placeBasketOrder();
      await removeFromBasket();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful'),
          )
      );

    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Unsuccessful'),
          )
      );
    }
  }

  removeFromBasket() async {
    await FirebaseDatabase.instance.reference().child('basket/${_user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}').remove();
  }


  placeBasketOrder() async {
    Map<dynamic, dynamic> basket = {};
    basket['customer id'] = _user.getUserEmail().replaceAll('.', '-');
    basket['item'] = {};
    basket['restaurant id'] = widget.restaurantId;
    basket['service mode'] = 'dine in';
    basket['status'] = 'in progress';
    basket['comment'] = ' ';
    basket['rating'] = ' ';
    basket['date'] = DateTime.now().toString().substring(0, 19);
    await FirebaseDatabase.instance.reference().child('basket/${_user.getUserEmail().replaceAll('.', '-')}/${widget.restaurantId}').once().then((snapshot) async{
      // print(snapshot.value);
      final value = Map<dynamic, dynamic>.from(snapshot.value);
      value.forEach((key, value) async{
        setState(() {
          basket['item'][key] = value.toString();
        });
      });
    });
    print(basket);

    FirebaseDatabase.instance.reference().child('order').push().set(basket);

  }


}
