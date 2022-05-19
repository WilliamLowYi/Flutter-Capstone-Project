import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:new_customer_ui/models/order.dart';
import 'package:new_customer_ui/widget/history_widget.dart';

import '../models/customer_user.dart';
import '../utility/colors.dart';
import '../utility/dimensions.dart';
import '../utility/firebase_rtdb_assistant.dart';
import '../widget/text_big_style.dart';
import '../widget/text_small_style.dart';

class AllHistoryPage extends StatelessWidget {
  AllHistoryPage({Key? key}) : super(key: key);

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
                  TextBigStyle(text: 'Your History', fontWeight: FontWeight.w600,),
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
                stream: _rtdbAssistant.getOrderStream(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> listOfWidgets = [];
                  if (snapshot.data != null) {
                    if ((snapshot.data as Event).snapshot.value != null) {
                      Map<dynamic, dynamic> data = Map.from((snapshot.data as Event).snapshot.value);
                      data.forEach((key, value) {
                        print(value['customer id'] == _user.getUserEmail());
                        if (value['customer id'] == _user.getUserEmail()) {
                          Order order = Order();
                          order.fromJson(value);
                          listOfWidgets.add(HistoryWidget(orderId: key, orderData: order));
                        }
                      });
                    }
                  }
                  if (listOfWidgets.isEmpty){
                    listOfWidgets.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextSmallStyle(
                            text: 'You haven\'t logged in yet.',
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
