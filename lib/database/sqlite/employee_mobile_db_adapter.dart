import '../../data/model/employee.dart';
import '../interface/employee_db_interface.dart';
import 'employee_db_helper.dart';

class EmployeeDBAdapter implements EmployeeDBInterface {
  final EmployeeDBHelper _dbHelper;

  EmployeeDBAdapter(this._dbHelper);

  @override
  Future<int> insertEmployee(Employee employee) {
    return _dbHelper.saveEmployee(employee);
  }

  @override
  Future<int> updateEmployee(int id, Employee employee) {
    return _dbHelper.updateEmployee(id, employee);
  }

  @override
  Future<int> deleteEmployee(int id) {
    return _dbHelper.deleteEmployee(id);
  }

  @override
  Future<List<Employee>> getCurrentEmployees() {
    return _dbHelper.getCurrentEmployees();
  }

  @override
  Future<List<Employee>> getPreviousEmployees() {
    return _dbHelper.getPastEmployees();
  }
}