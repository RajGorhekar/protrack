import 'package:flutter/material.dart';

class UserCircle extends StatelessWidget {
  final String url1;
  final String url2;
  final double size;

  const UserCircle(
      {Key key,
      this.url1 = "assets/images/user.jpg",
      this.url2 = "",
      this.size = 50.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38 ,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey[50],
        child: ClipOval(
          child: Stack(
            children: [
              Image.asset(url1,height: size,width: size,fit: BoxFit.fill,),
              Image.network(url2,height: size,width: size,fit: BoxFit.fill),
              // Container(
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //     image: url2 == "" ? NetworkImage("") : NetworkImage(url2),
              //     fit: BoxFit.fill,
              //     alignment: FractionalOffset.center,
              //   )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
