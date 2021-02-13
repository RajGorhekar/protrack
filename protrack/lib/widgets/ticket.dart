import 'package:flutter/material.dart';
import 'package:protrack/utils/colors.dart';
import 'package:protrack/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class Ticket extends StatefulWidget {
  final String barcodeurl;
  final String eventName;
  final String eventDateAndTime;
  final bool registered;
  final Function onTap;
  final Key key;
  final String link;

  Ticket(
      {this.barcodeurl,
      this.eventName,
      this.eventDateAndTime,
      this.registered = false,
      this.onTap,
      this.link,
      this.key});
  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  Widget dashContainer = Container(
    width: 1,
    height: 5,
    color: Colors.white54,
  );

  Widget curve(x) {
    return SizedBox(
      height: 10,
      width: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: x == 0 ? Radius.circular(5) : Radius.circular(0),
              bottomRight: x == 0 ? Radius.circular(5) : Radius.circular(0),
              topLeft: x == 0 ? Radius.circular(0) : Radius.circular(5),
              bottomLeft: x == 0 ? Radius.circular(0) : Radius.circular(5),
            ),
            color: AppColors.bgGray),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Link is : " + widget.link.toString());
    return Container(
      color: AppColors.fgGray,
      height: 100,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                curve(0),
                curve(0),
                curve(0),
                curve(0),
                curve(0),
                SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: widget.registered
                ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        widget.barcodeurl,
                      ),
                    ),
                  )
                : BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      image: AssetImage(
                        widget.barcodeurl,
                      ),
                    ),
                  ),
            child: !widget.registered
                ? Icon(
                    Icons.lock_clock,
                    size: 35,
                    color: AppColors.fgGray,
                  )
                : SizedBox(height: 0),
          ),
          Container(
            width: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 8,
                  width: 15,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: AppColors.bgGray),
                  ),
                ),
                dashContainer,
                dashContainer,
                dashContainer,
                dashContainer,
                dashContainer,
                dashContainer,
                dashContainer,
                SizedBox(
                  height: 8,
                  width: 15,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        color: AppColors.bgGray),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(children: [
                        Icon(Icons.event,
                            size: 20, color: AppColors.iconColorInProfile),
                        SizedBox(width: 8),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width*0.5
                          ),
                          child: Text(
                            widget.eventName, 
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.eventDateAndTime,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.registered &&
                                widget.link != "" &&
                                widget.link != null
                            ? InkWell(
                                onTap: () async {
                                  print(widget.link);
                                  if (await canLaunch(widget.link)) {
                                    await launch(widget.link);
                                  } else {
                                    print("Could not launch url");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 0,
                                          blurRadius: 25,
                                          offset: Offset(15,
                                              15), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.red,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.copy,
                                                size: 8,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Link  ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        widget.registered
                            ? InkWell(
                                onTap: () {
                                  widget.onTap();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.cyan[100],
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 0,
                                          blurRadius: 25,
                                          offset: Offset(15,
                                              15), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: AppColors.iconColorInProfile,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.iconColorInProfile,
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.file_download,
                                                size: 8,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Receipt ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          decoration: BoxDecoration(
                              color: widget.registered
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(4.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 25,
                                  offset: Offset(
                                      15, 15), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                color: widget.registered
                                    ? Colors.green
                                    : Colors.orange,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: widget.registered
                                          ? Colors.green
                                          : Colors.orange,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        widget.registered
                                            ? Icons.verified
                                            : Icons.not_interested,
                                        size: 8,
                                        color: Colors.white,
                                      )),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  widget.registered
                                      ? "Registered "
                                      : "Interested ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        color: AppColors.bgGray),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
