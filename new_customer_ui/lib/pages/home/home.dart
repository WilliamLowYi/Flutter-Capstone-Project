import 'package:flutter/material.dart';
import 'package:new_customer_ui/pages/all_history.dart';
import 'package:new_customer_ui/pages/home/main_food_page.dart';

import '../../utility/colors.dart';
import '../cart/all_cart.dart';

class Home extends StatefulWidget {
  int selectedIndexWidget;
  Home({Key? key,
    this.selectedIndexWidget = 0,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  static final List<Widget> _widgetOptions = <Widget> [
    const MainFoodPage(),
    AllCartPage(),
    AllHistoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndexWidget = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationColors.backgroundColor,
      body: _widgetOptions.elementAt(widget.selectedIndexWidget),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: 'Cart'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History'
          ),
        ],
        currentIndex: widget.selectedIndexWidget,
        onTap: _onItemTapped,
      ),
    );
  }
}
