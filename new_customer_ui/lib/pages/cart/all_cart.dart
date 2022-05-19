import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_customer_ui/models/cart_item.dart';
import 'package:new_customer_ui/models/customer_user.dart';
import 'package:new_customer_ui/utility/firebase_rtdb_assistant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../../utility/colors.dart';
import '../../utility/dimensions.dart';
import '../../widget/cart_widget.dart';
import '../../widget/text_big_style.dart';

class AllCartPage extends StatelessWidget {
  AllCartPage({Key? key}) : super(key: key);

  final CustomerUser _user = CustomerUser(FirebaseAuth.instance.currentUser);
  final RTDBAssistant _rtdbAssistant = RTDBAssistant();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // App Bar
          Container(
            color: ApplicationColors.white,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBigStyle(text: 'Your Cart', fontWeight: FontWeight.w600,),
                  Center(
                    child: Container(
                      child: Icon(Icons.account_circle, size: ApplicationDimensions.iconSize24 ,color: Colors.white,),
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
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: _rtdbAssistant.getBasketStream(_user.getUserEmail()),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> listOfWidgets = [];
                  if (snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {
                    final data = Map<dynamic, dynamic>.from((snapshot.data as Event).snapshot.value as Map<dynamic, dynamic>);
                    data.forEach((key, value) {
                      listOfWidgets.add(CartWidget(cartItem: CartItem(key, value)));
                    });
                  }
                  if (listOfWidgets.isEmpty){
                    listOfWidgets.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextSmallStyle(
                            text: _user.isUserLoggedIn() ?
                            'Try add some of your desire food in cart.':
                            'You haven\'t logged in yet.',

                          )
                        ],
                      )
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: ApplicationDimensions.vertical(20.0)),
                    child: Column(
                      children: listOfWidgets
                    ),
                  );
                },
              ),
            )
          )
        ],
      ),
    );
  }
}
