import 'package:flutter/material.dart';
import 'package:protrack/utils/colors.dart';

class InfoText extends StatelessWidget {
  final List<String> s;

  InfoText(this.s);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> children = [];

    for (var i = 0; i < s.length; i++) {
      children.add(
        TextSpan(
          text: '⦿',
        ),
      );
      children.add(
        TextSpan(
          text: s[i],
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return Container(
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            text: '',
            style: TextStyle(
              color: AppColors.blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            children: children),
      ),
    );
  }
}
