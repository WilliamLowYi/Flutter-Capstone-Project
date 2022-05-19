import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_customer_ui/utility/colors.dart';
import 'package:new_customer_ui/widget/menu_card.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../models/food.dart';
import '../utility/dimensions.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;
  const MenuPage({Key? key,
    required this.restaurantId
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors.color30,
      appBar: AppBar(
        title: StreamBuilder<Object>(
          stream: FirebaseDatabase.instance.reference().child('restaurant/${widget.restaurantId}/name').onValue,
          builder: (context, snapshot) {
            return Text(snapshot.hasData ? (snapshot.data as Event).snapshot.value : widget.restaurantId);
          }
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List of Menu Card
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: ApplicationDimensions.vertical(5.0)),
                child: StreamBuilder<Object>(
                  stream:  FirebaseDatabase.instance.reference().child('restaurant/${widget.restaurantId}/menu').onValue,
                  builder: (context, snapshot) {
                    List<Widget> foodCardList = [];
                    if ((snapshot.data as Event).snapshot.value != null) {
                      Map<dynamic, dynamic> data = Map.from((snapshot.data as Event).snapshot.value);
                      data.forEach((key, value) {
                        Food food = Food.fromJson(value, key);
                        foodCardList.add(MenuCard(food: food, restaurantId: widget.restaurantId));
                      });
                    } else {
                      foodCardList.add(
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ApplicationDimensions.vertical(20.0),
                              horizontal: ApplicationDimensions.horizontal(10.0)
                            ),
                            child: TextSmallStyle(
                              text: 'There are no food available in the menu.',
                              size: ApplicationDimensions.smallTextSize + ApplicationDimensions.vertical(5.0)
                            ),
                          ),
                        )
                      );
                    }
                    return Column(
                      children: foodCardList,
                    );
                  }
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}
