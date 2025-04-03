import 'package:flutter/material.dart';

import 'model/route_arguments.dart';

class AppRouter {

  static Future<T?> push<T extends Object?>(BuildContext context, String routeName, {RouteArguments? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<T?> replace<T extends Object?>(BuildContext context, String routeName, {RouteArguments? arguments}) {
    return Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
