import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/string_extensions.dart';
import '../../../data/model/employee.dart';
import '../repo/employee_repo.dart';
import '../states/employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepo _employeeRepo = EmployeeRepo();
  final List<Employee> _deletedEmployees = List.empty(growable: true);
  final Map<int, int> _employeePosition = {};
  final Map<int, Timer> _deleteTimers = {};

  EmployeeCubit() : super(EmployeeInitialState());

  Future<void> clearValidation() async {
    emit(EmployeeInitialState());
  }

  Future<void> validate(Employee employee) async {
    final validationState = _getValidationState(employee);
    emit(validationState);
  }

  Future<void> addEmployee(Employee employee) async {
    final validationState = _getValidationState(employee, isSave: true);
    if (validationState.hasError) {
      emit(validationState);
    } else {
      emit(UpdatingEmployeeDetailsState());
      final result = await _employeeRepo.saveEmployee(employee);
      if (result.isSuccess) {
        emit(EmployeeDetailsAddedState(employee: result.data!));
      } else {
        emit(EmployeeDetailsUpdateErrorState(message: result.error ?? 'Unknown Error'));
      }
    }
  }

  Future<void> updateEmployee(int index, int employeeId, Employee employee) async {
    final validationState = _getValidationState(employee);
    if (validationState.hasError) {
      emit(validationState);
    } else {
      emit(UpdatingEmployeeDetailsState());
      final result = await _employeeRepo.updateEmployee(employeeId, employee);
      if (result.isSuccess) {
        emit(EmployeeDetailsUpdatedState(index: index, employee: result.data!));
      } else {
        emit(EmployeeDetailsUpdateErrorState(message: result.error ?? 'Unknown Error'));
      }
    }
  }

  Future<void> deleteEmployee(Employee employee, int index) async {
    emit(UpdatingEmployeeDetailsState());

    //delete previous queued deletion
    if (_deleteTimers.isNotEmpty) {
      _deleteTimers.forEach((id, timer) {
        timer.cancel();
        final pendingEmployee = _deletedEmployees.firstWhere((e) => e.id == id, orElse: Employee.new);
        if (pendingEmployee.id != null) {
          _employeeRepo.deleteEmployee(id); // Ensure the previous delete executes
        }
      });
    }

    // Clear all previous undo-related data
    _deleteTimers.clear();
    _deletedEmployees.clear();
    _employeePosition.clear();

    _deletedEmployees.add(employee);
    _employeePosition[employee.id!] = index;
    emit(EmployeeDetailsDeletedState(index: index, employee: employee));

    _deleteTimers[employee.id!] = Timer(const Duration(seconds: 3), () async {
      //delete the employee from local database
      _deletedEmployees.remove(employee);
      _deleteTimers.remove(employee.id!);
      final result = await _employeeRepo.deleteEmployee(employee.id!);
      if (result.isSuccess) {
        emit(EmployeeDetailsDeletedState(index: index, employee: employee));
      } else {
        emit(EmployeeDetailsUpdateErrorState(message: result.error ?? 'Unknown Error'));
      }
    });

    /* final result = await _employeeRepo.deleteEmployee(employee.id!);
    if (result.isSuccess) {
      emit(EmployeeDetailsDeletedState(index: index, employee: employee));
    } else {
      emit(EmployeeDetailsUpdateErrorState(message: result.error ?? 'Unknown Error'));
    }*/
  }

  void undoDelete(Employee employee) {
    if (_deletedEmployees.contains(employee)) {
      _deletedEmployees.remove(employee);
      _deleteTimers[employee.id!]?.cancel();
      emit(EmployeeDetailsAddedState(employee: employee, index: _employeePosition[employee.id!] ?? 0, notify: false));
    }
  }

  EmployeeValidationState _getValidationState(Employee employee, {bool isSave = false}) {
    final validationState = EmployeeValidationState();
    validationState.nameError = employee.name.isNullOrTrimEmpty ? 'Enter employee name' : null;
    if (isSave) {
      //validate job title only if user taps on save, otherwise not required
      validationState.jobTitleError = employee.jobTitle.isNullOrTrimEmpty ? 'Select a role' : null;
    }
    validationState.hasError = validationState.nameError != null || (validationState.jobTitleError != null && isSave);
    return validationState;
  }
}
