import 'package:flutter/cupertino.dart';
import 'package:new_customer_ui/utility/colors.dart';
import 'package:new_customer_ui/utility/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  late double containerSize;
  late double appIconSize;
  AppIcon({Key? key,
    required this.icon,
    this.backgroundColor = ApplicationColors.color10Light,
    this.iconColor = ApplicationColors.blackColor,
    this.containerSize = 0,
    this.appIconSize = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (containerSize == 0) { containerSize = ApplicationDimensions.appIconContainerSize; }
    if (appIconSize == 0) { appIconSize = ApplicationDimensions.appIconSize; }

    return Container(
      child: Icon(
        icon,
        color: iconColor,
        size: appIconSize,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(containerSize / 2),
      ),
      width: containerSize,
      height: containerSize,
    );
  }
}
