import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/routes/routes.dart';
import '../../../common/widgets/safe_padding.dart';
import '../../../core/navigation/app_router.dart';
import '../../../database/sqlite/employee_db.dart';
import '../../../database/sqlite/employee_db_helper.dart';
import '../../employee/cubits/employee_list_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Assignment 2', textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 8),
                    if (_errorText == null)
                      const SizedBox.square(dimension: 24, child: CircularProgressIndicator())
                    else
                      Text(_errorText!, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const Column(
              children: [
                Text('Done by', style: TextStyle(color: Colors.black45)),
                Text('Senthamizh Raj Thiruneelakandan', style: TextStyle(fontWeight: FontWeight.w500)),
                SafePadding(extraHeight: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startTimer() async {
    try {
      setState(() {
        _errorText = 'Initializing database...';
      });
      await EmployeeDB.instance.ensureInitialized();
      setState(() {
        _errorText = 'Loading database...';
      });
      if (mounted) {
        unawaited(context.read<EmployeeListCubit>().loadEmployees());
      }
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        unawaited(AppRouter.replace(context, Routes.employeeList));
      }
    } catch (error) {
      setState(() {
        _errorText = error as String?;
      });
    }
  }
}
