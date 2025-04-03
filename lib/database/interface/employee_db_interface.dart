import '../../data/model/employee.dart';

abstract class EmployeeDBInterface {
  Future<int> insertEmployee(Employee employee);
  Future<int> updateEmployee(int employeeId, Employee employee);
  Future<int> deleteEmployee(int employeeId);
  Future<List<Employee>> getCurrentEmployees();
  Future<List<Employee>> getPreviousEmployees();
}
