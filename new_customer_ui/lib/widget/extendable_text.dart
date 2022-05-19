import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_customer_ui/utility/colors.dart';
import 'package:new_customer_ui/widget/text_small_style.dart';

import '../utility/dimensions.dart';
import 'app_icon.dart';

class ExtendableText extends StatefulWidget {
  final String text;
  const ExtendableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExtendableText> createState() => _ExtendableTextState();
}

class _ExtendableTextState extends State<ExtendableText> {
  late String firstHalf, secondHalf;
  late bool hideText = true;
  double textHeight = ApplicationDimensions.vertical(100);

  @override
  void initState(){
    super.initState();
    if ( widget.text.length > textHeight ) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty ?
      // All the text information
      TextSmallStyle(
        text: firstHalf,
        size: ApplicationDimensions.vertical(16.0),
        color: ApplicationColors.textColor,
        textHeight: 1.5 ,
        textOverflow: TextOverflow.visible,
        softWrap: true,
        maxLines: 5,
      ) :
      // Text with 'show more' / 'show less'
      Column(
        children: [
          TextSmallStyle(
            text: hideText ? (firstHalf + '...') : (firstHalf + secondHalf),
            size: ApplicationDimensions.vertical(16.0),
            textHeight: 1.5 ,
            color: ApplicationColors.textColor,
            maxLines: 99,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                hideText = !hideText;
              });
            },
            child: Row(
              children: [
                TextSmallStyle(
                  text: hideText ? 'Show more' : 'Show less',
                  color: ApplicationColors.color10
                ),
                Icon(
                  hideText? Icons.arrow_drop_down : Icons.arrow_drop_up,
                  color: ApplicationColors.color10,
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}
