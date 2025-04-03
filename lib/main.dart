import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/routes/route_handler.dart';
import 'common/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'features/employee/cubits/employee_cubit.dart';
import 'features/employee/cubits/employee_list_cubit.dart';
import 'features/launcher/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeListCubit>(create: (_) => EmployeeListCubit()),
        BlocProvider<EmployeeCubit>(create: (_) => EmployeeCubit()),
      ],
      child: MaterialApp(
        title: 'Senthamizh',
        onGenerateRoute: RouteHandler.onGenerateRoute,
        navigatorKey: Routes.navigatorKey,
        initialRoute: '/',
        theme: AppTheme.light,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (kIsWeb) {
                return Center(
                  child: Container(
                    width: 390,
                    constraints: const BoxConstraints(maxWidth: 390),
                    decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
                    child: Navigator(key: Routes.navigatorKey, onGenerateRoute: RouteHandler.onGenerateRoute),
                  ),
                );
              }
              return child ?? const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
