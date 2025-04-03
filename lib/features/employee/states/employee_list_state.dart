import '../../../data/model/employee.dart';

abstract class EmployeeListState {
  final List<Employee> employees;
  final List<Employee> pastEmployees;

  EmployeeListState({required this.employees, required this.pastEmployees});
}

class EmployeeListInitialState extends EmployeeListState {
  EmployeeListInitialState() : super(employees: List.empty(growable: true), pastEmployees: List.empty(growable: true));
}

class LoadingEmployeesState extends EmployeeListState {
  LoadingEmployeesState({required super.employees, required super.pastEmployees});
}

class EmployeesLoadedState extends EmployeeListState {
  EmployeesLoadedState({required super.employees, required super.pastEmployees});
}

class LoadEmployeesErrorState extends EmployeeListState {
  final String message;
  LoadEmployeesErrorState({required this.message, required super.employees, required super.pastEmployees});
}
