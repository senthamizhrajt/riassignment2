import '../../../api/base/api_result.dart';
import '../../../data/model/employee.dart';
import '../../../database/sqlite/employee_db.dart';
import '../../../database/sqlite/employee_db_helper.dart';

class EmployeeRepo {

  Future<ApiResult<List<Employee>>> getCurrentEmployees() async {
    ApiResult<List<Employee>> apiResult = ApiResult(
      error: 'Unable to get employee records at the moment. Please try again later.',
    );
    try {
      final List<Employee> employees = await EmployeeDB.instance.getCurrentEmployees();
      apiResult = ApiResult(data: employees);
    } catch (error) {
      //do nothing
    }
    return apiResult;
  }

  Future<ApiResult<List<Employee>>> getPastEmployees() async {
    ApiResult<List<Employee>> apiResult = ApiResult(
      error: 'Unable to get employee records at the moment. Please try again later.',
    );
    try {
      final List<Employee> employees = await EmployeeDB.instance.getPreviousEmployees();
      apiResult = ApiResult(data: employees);
    } catch (error) {
      //do nothing
    }
    return apiResult;
  }

  Future<ApiResult<Employee>> saveEmployee(Employee employee) async {
    ApiResult<Employee> apiResult = ApiResult(error: 'Unable to save employee at the moment. Please try again later.');
    try {
      final insertId = await EmployeeDB.instance.insert(employee);
      if (insertId != 0) {
        apiResult = ApiResult(data: employee.copyWith(id: insertId));
      }
    } catch (error) {
      //do nothing
    }
    return apiResult;
  }

  Future<ApiResult<Employee>> updateEmployee(int employeeId, Employee employee) async {
    ApiResult<Employee> apiResult = ApiResult(
      error: 'Unable to update employee at the moment. Please try again later.',
    );
    try {
      final updateCount = await EmployeeDB.instance.update(employeeId, employee);
      if (updateCount != 0) {
        apiResult = ApiResult(data: employee.copyWith(id: employeeId));
      }
    } catch (error) {
      //do nothing
    }
    return apiResult;
  }

  Future<ApiResult<int>> deleteEmployee(int employeeId) async {
    ApiResult<int> apiResult = ApiResult(error: 'Unable to delete employee at the moment. Please try again later.');
    try {
      final updateCount = await EmployeeDB.instance.delete(employeeId);
      if (updateCount != 0) {
        apiResult = ApiResult(data: 1);
      }
    } catch (error) {
      //do nothing
    }
    return apiResult;
  }
}
