import 'package:flutter/material.dart';
import 'package:spdometer_socialtitli/views/home_view.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(HomeView());
}

