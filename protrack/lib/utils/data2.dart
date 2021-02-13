import 'package:flutter/material.dart';

class EventNamesAndDetails {
  String name;
  String category;
  TimeOfDay start_time;
  TimeOfDay end_time;
  Color border;

  EventNamesAndDetails({
    this.name,
    this.category,
    this.start_time,
    this.end_time,
    this.border
  });
}