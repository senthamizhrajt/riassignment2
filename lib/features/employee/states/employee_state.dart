import '../../../data/model/employee.dart';

abstract class EmployeeState {}

class EmployeeInitialState extends EmployeeState {
  EmployeeInitialState();
}

class EmployeeValidationState extends EmployeeState {
  bool hasError;
  String? nameError;
  String? jobTitleError;
  EmployeeValidationState({this.hasError = false, this.nameError, this.jobTitleError});
}

class UpdatingEmployeeDetailsState extends EmployeeState {
  UpdatingEmployeeDetailsState();
}

class EmployeeDetailsAddedState extends EmployeeState {
  final int index;
  final Employee employee;
  final bool notify;
  EmployeeDetailsAddedState({required this.employee, this.index = 0, this.notify = true});
}

class EmployeeDetailsUpdatedState extends EmployeeState {
  final Employee employee;
  final int index;
  EmployeeDetailsUpdatedState({required this.index, required this.employee});
}

class EmployeeDetailsDeletedState extends EmployeeState {
  final int index;
  final Employee employee;
  EmployeeDetailsDeletedState({required this.index, required this.employee});
}

class EmployeeDetailsUpdateErrorState extends EmployeeState {
  final String message;
  EmployeeDetailsUpdateErrorState({required this.message});
}
