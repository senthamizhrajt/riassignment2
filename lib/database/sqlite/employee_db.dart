import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../data/model/employee.dart';
import '../interface/employee_db_interface.dart';
import 'employee_db_helper.dart';
import 'employee_mobile_db_adapter.dart';
import 'employee_web_db_adapter.dart';

class EmployeeDB {
  static final EmployeeDB _instance = EmployeeDB._internal();
  late EmployeeDBInterface _adapter;

  EmployeeDB._internal();

  static EmployeeDB get instance => _instance;

  Future<void> ensureInitialized() async {
    if (kIsWeb) {
      _adapter = EmployeeDBWebAdapter();
    } else {
      final EmployeeDBHelper dbHelper = EmployeeDBHelper();
      await dbHelper.ensureInitialized();
      _adapter = EmployeeDBAdapter(dbHelper);
    }
  }

  Future<int> insert(Employee employee) => _adapter.insertEmployee(employee);
  Future<int> update(int id, Employee employee) => _adapter.updateEmployee(id, employee);
  Future<int> delete(int id) => _adapter.deleteEmployee(id);
  Future<List<Employee>> getCurrentEmployees() => _adapter.getCurrentEmployees();
  Future<List<Employee>> getPreviousEmployees() => _adapter.getPreviousEmployees();
}