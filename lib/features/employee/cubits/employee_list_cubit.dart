import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/base/api_result.dart';
import '../../../data/model/employee.dart';
import '../../../database/sqlite/employee_db_helper.dart';
import '../repo/employee_repo.dart';
import '../states/employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  final EmployeeRepo _employeeRepo = EmployeeRepo();

  EmployeeListCubit() : super(EmployeeListInitialState());

  Future<void> loadEmployees() async {
    emit(LoadingEmployeesState(employees: state.employees, pastEmployees: state.pastEmployees));
    final List<Employee> currentEmployees = List.empty(growable: true);
    final List<Employee> pastEmployees = List.empty(growable: true);
    ApiResult<List<Employee>> apiResult = await _employeeRepo.getCurrentEmployees();
    if (apiResult.isSuccess) {
      currentEmployees.addAll(apiResult.data ?? []);
    }
    apiResult = await _employeeRepo.getPastEmployees();
    if (apiResult.isSuccess) {
      pastEmployees.addAll(apiResult.data ?? []);
    }
    emit(EmployeesLoadedState(employees: currentEmployees, pastEmployees: pastEmployees));
  }

  Future<void> addEmployee(Employee employee, int index) async {
    if (employee.toDate != null) {
      state.pastEmployees.insert(index, employee);
    }
    else {
      state.employees.insert(index, employee);
    }
    emit(EmployeesLoadedState(employees: state.employees, pastEmployees: state.pastEmployees));
  }

  Future<void> updateEmployee(Employee employee, bool shouldRemoveFromCurrentEmployees, int index) async {
    if (shouldRemoveFromCurrentEmployees) {
      state.employees.removeAt(index);
      state.pastEmployees.insert(0, employee);
    } else {
      if (employee.toDate != null) {
        state.pastEmployees[index] = employee;
      } else {
        state.employees[index] = employee;
      }
    }
    emit(EmployeesLoadedState(employees: state.employees, pastEmployees: state.pastEmployees));
  }

  Future<void> deleteEmployee(int index, Employee employee) async {
    if (employee.toDate != null) {
      state.pastEmployees.remove(employee);
    } else {
      state.employees.remove(employee);
    }
    // state.employees.removeAt(index);
    emit(EmployeesLoadedState(employees: state.employees, pastEmployees: state.pastEmployees));
  }
}
