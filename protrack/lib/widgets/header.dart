import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final icon, title, subtitle;

  const Header(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle == "" ? SizedBox(height: 0) : SizedBox(height: 5),
            subtitle == ""
                ? SizedBox(height: 0)
                : Container(
                    alignment: Alignment.centerLeft,
                    padding : EdgeInsets.only(left :4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
          ],
        ));
  }
}
