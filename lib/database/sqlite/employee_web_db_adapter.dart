import '../../data/model/employee.dart';
import '../interface/employee_db_interface.dart';

class EmployeeDBWebAdapter implements EmployeeDBInterface {
  Future<void> ensureInitialized() async {}

  @override
  Future<int> insertEmployee(Employee employee) async {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  @override
  Future<int> updateEmployee(int employeeId, Employee employee) async {
    return employeeId;
  }

  @override
  Future<int> deleteEmployee(int id) async {
    return id;
  }

  @override
  Future<List<Employee>> getCurrentEmployees() {
    return Future.value([]);
  }

  @override
  Future<List<Employee>> getPreviousEmployees() {
    return Future.value([]);
  }
}
