
import 'package:flutter/cupertino.dart';
import 'package:new_customer_ui/utility/dimensions.dart';
import '../utility/colors.dart';

class TextBigStyle extends StatelessWidget {
  final String text;
  double size;
  TextOverflow textOverflow;
  bool softWrap;
  Color? color;
  FontWeight fontWeight;
  int maxLines;
  TextBigStyle({Key? key,
    required this.text,
    this.size = 0,
    this.textOverflow = TextOverflow.ellipsis,
    this.softWrap = false,
    this.color = ApplicationColors.appColor,
    this.fontWeight = ApplicationDimensions.bigFontWeight,
    this.maxLines = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size == 0? ApplicationDimensions.bigTextSize : size,
        fontWeight: fontWeight,
        fontFamily: 'Roboto',
        color: color
      ),
      overflow: textOverflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }
}
