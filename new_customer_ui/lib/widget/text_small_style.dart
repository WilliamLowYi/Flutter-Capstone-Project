import 'package:flutter/cupertino.dart';
import 'package:new_customer_ui/utility/dimensions.dart';

import '../utility/colors.dart';

class TextSmallStyle extends StatelessWidget {
  final String text;
  double size;
  bool softWrap;
  Color color;
  double textHeight;
  FontWeight fontWeight;
  TextOverflow textOverflow;
  int maxLines;
  TextSmallStyle({Key? key,
    required this.text,
    this.textOverflow = TextOverflow.ellipsis,
    this.size = 0,
    this.softWrap = false,
    this.color = ApplicationColors.textColor,
    this.textHeight = 1.2,
    this.fontWeight = ApplicationDimensions.smallFontWeight,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size != 0? size : ApplicationDimensions.smallTextSize,
        fontFamily: 'Roboto',
        fontWeight: fontWeight,
        color: color,
      ),
      softWrap: softWrap,
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
