import 'package:flutter/material.dart';

import '../../core/navigation/model/route_arguments.dart';
import '../../features/employee/screens/add_employee_screen.dart';
import '../../features/employee/screens/employee_list_screen.dart';
import '../../features/launcher/screens/splash_screen.dart';
import 'arguments/add_employee_route_arguments.dart';
import 'routes.dart';

class RouteHandler {
  static PageRoute<dynamic>? onGenerateRoute(RouteSettings settings) {
    PageRoute? route;
    final RouteArguments? args = settings.arguments as RouteArguments?;
    switch (settings.name) {
      case Routes.splash:
        route = MaterialPageRoute(settings: settings, builder: (context) => const SplashScreen());
        break;
      case Routes.employeeList:
        route = MaterialPageRoute(settings: settings, builder: (context) => const EmployeeListScreen());
        break;
      case Routes.addEmployee:
        if (args != null && args is AddEmployeeRouteArguments) {
          route = MaterialPageRoute(
            settings: settings,
            builder: (context) => AddEmployeeScreen(employee: args.employee, index: args.index),
          );
        } else {
          route = MaterialPageRoute(settings: settings, builder: (context) => const AddEmployeeScreen());
        }
        break;
      default:
        route = _getUnknownPageRoute(settings);
        break;
    }
    return route;
  }
}

PageRoute _getMissingArgumentPageRoute(RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => const Scaffold(body: Center(child: Text('Missing required parameters'))),
  );
}

PageRoute _getUnknownPageRoute(RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => const Scaffold(body: Center(child: Text('Route not Found'))),
  );
}

class Fade<T> extends PageRouteBuilder<T> {
  final Widget page;

  Fade({required this.page, required super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) => page,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget page,
        ) {
          final CurvedAnimation curvedAnimation = CurvedAnimation(parent: animation1, curve: Curves.ease);
          return FadeTransition(opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation), child: page);
        },
      );
}
