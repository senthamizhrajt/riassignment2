import 'package:flutter/material.dart';

class Routes {
  static const splash = '/';
  static const employeeList = '/employeeList';
  static const addEmployee = '/addEmployee';

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}
