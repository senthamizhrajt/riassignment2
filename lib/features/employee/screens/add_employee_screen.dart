import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/date_utils.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_snackbar.dart';
import '../../../common/widgets/asset_graphic.dart';
import '../../../common/widgets/extended_text_field.dart';
import '../../../common/widgets/progress_dialog.dart';
import '../../../common/widgets/safe_padding.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/assets.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/model/employee.dart';
import '../cubits/employee_cubit.dart';
import '../cubits/employee_list_cubit.dart';
import '../dialogs/date_picker.dart';
import '../states/employee_state.dart';
import '../widgets/calendar/calendar_widget.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  final int? index;

  const AddEmployeeScreen({this.employee, this.index, super.key});

  @override
  State createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  String _fromDate = DateTime.now().toIso8601String();
  String? _toDate;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _jobTitleEditingController = TextEditingController();
  final TextEditingController _fromDateEditingController = TextEditingController();
  final TextEditingController _toDateEditingController = TextEditingController();

  late EmployeeCubit _employeeCubit;
  bool _isRemoveFromCurrent = false;

  @override
  void initState() {
    super.initState();
    _employeeCubit = context.read<EmployeeCubit>();
    if (widget.employee != null && widget.index != null) {
      _nameEditingController.text = widget.employee?.name ?? '';
      _jobTitleEditingController.text = widget.employee?.jobTitle ?? '';
      if (widget.employee?.fromDate != null) {
        _fromDate = widget.employee!.fromDate!;
        _fromDateEditingController.text = DateTimeUtils.formatIsoDate(widget.employee!.fromDate!).replaceAll(',', '');
      }
      if (widget.employee?.toDate != null) {
        _toDate = widget.employee!.toDate!;
        _toDateEditingController.text = DateTimeUtils.formatIsoDate(widget.employee!.toDate!).replaceAll(',', '');
      }
    } else {
      _fromDateEditingController.text = 'Today';
    }
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _jobTitleEditingController.dispose();
    _fromDateEditingController.dispose();
    _toDateEditingController.dispose();
    _employeeCubit.clearValidation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.employee != null ? 'Edit' : 'Add'} Employee Details'),
        actions: [
          if (widget.employee != null && widget.index != null)
            IconButton(
              onPressed: () {
                _employeeCubit.deleteEmployee(widget.employee!, widget.index!);
              },
              icon: AssetGraphic(path: Assets.icons.delete, width: 24),
            ),
        ],
      ),
      body: Column(
        children: [
          BlocListener<EmployeeCubit, EmployeeState>(listener: _listenStateChanges, child: const SizedBox.shrink()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  BlocBuilder<EmployeeCubit, EmployeeState>(
                    buildWhen: (previous, current) => current is EmployeeValidationState,
                    builder: (context, state) {
                      return ExtendedTextField(
                        controller: _nameEditingController,
                        hintText: 'Employee Name',
                        errorText: state is EmployeeValidationState ? state.nameError : null,
                        prefixIcon: AssetGraphic(path: Assets.icons.person),
                        onChanged: (value) {
                          _validateForm();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 23),
                  BlocBuilder<EmployeeCubit, EmployeeState>(
                    buildWhen: (previous, current) => current is EmployeeValidationState,
                    builder: (context, state) {
                      return ExtendedTextField(
                        controller: _jobTitleEditingController,
                        hintText: 'Select Role',
                        errorText: state is EmployeeValidationState ? state.jobTitleError : null,
                        prefixIcon: AssetGraphic(path: Assets.icons.work),
                        suffixIcon: AssetGraphic(path: Assets.icons.arrowDownBlue),
                        isReadOnly: true,
                        onTap: _showJobTitlesSheet,
                      );
                    },
                  ),
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      Expanded(
                        child: ExtendedTextField(
                          controller: _fromDateEditingController,
                          isReadOnly: true,
                          defaultText: 'Today',
                          prefixIcon: AssetGraphic(path: Assets.icons.calendar),
                          onTap: () {
                            final initialDate = DateTime.tryParse(_fromDate) ?? DateTime.now();
                            _showCalendar(selectedDate: initialDate);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AssetGraphic(path: Assets.icons.arrowRightBlue, width: 14),
                      ),
                      Expanded(
                        child: ExtendedTextField(
                          controller: _toDateEditingController,
                          isReadOnly: true,
                          hintText: 'To Date',
                          prefixIcon: AssetGraphic(path: Assets.icons.calendar),
                          onTap: () {
                            if (widget.employee == null) {
                              AppSnackBar.show(context, 'You cannot select to date for new employee');
                              return;
                            }

                            final initialDate = _toDate != null ? DateTime.tryParse(_toDate!) : null;

                            final DateTime now = DateTime.now();
                            final DateTime pageMonth = DateTime(now.year, now.month, 1);
                            final DateTime lastDayOfMonth = DateTime(pageMonth.year, pageMonth.month + 1, 0);
                            final DateTime startDate = DateTime.parse(_fromDate).subtract(Duration(days: 0));

                            _showCalendar(
                              selectedDate: initialDate,
                              startDate: startDate,
                              markedDate: lastDayOfMonth,
                              dateType: 1,
                              canClear: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _bottomActionWidgets(),
        ],
      ),
    );
  }

  Widget _bottomActionWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        children: [
          const Divider(height: 2),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: AppButton.secondary(
                  compact: true,
                  onPressed: _discardChanges,
                  text: 'Cancel',
                  style: const TextStyle(color: AppColors.primaryColor),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(child: AppButton.primary(compact: true, onPressed: _saveEmployee, text: 'Save')),
            ],
          ),
          const SafePadding(),
        ],
      ),
    );
  }

  void _showJobTitlesSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (BuildContext builder) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                setState(() {
                  _jobTitleEditingController.text = AppConstants.jobTitles[index];
                  _validateForm();
                });
                Navigator.of(context).pop();
              },
              titleAlignment: ListTileTitleAlignment.center,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                AppConstants.jobTitles[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Color(0xFF323238)),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 1, color: Theme.of(context).dividerColor);
          },
          itemCount: AppConstants.jobTitles.length,
        );
      },
    );
  }

  void _showCalendar({
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? markedDate,
    bool canClear = false,
    int dateType = 0,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: DatePicker(
            onDateSelected: (date) {
              if (dateType == 0) {
                _fromDate = date.toIso8601String();
                _fromDateEditingController.text = DateTimeUtils.formatIsoDate(_fromDate);
              } else {
                _toDate = date.toIso8601String();
                _toDateEditingController.text = DateTimeUtils.formatIsoDate(_toDate!);
              }
            },
            selectedDate: selectedDate,
            startDate: startDate,
            markedDate: markedDate,
            canClear: canClear,
          ),
        );
      },
    );
  }

  void _validateForm() {
    final employee = Employee(
      name: _nameEditingController.text.trim(),
      jobTitle: _jobTitleEditingController.text.trim(),
      fromDate: _fromDate,
      toDate: _toDate,
      createdAt: DateTime.now().toIso8601String(),
    );
    _employeeCubit.validate(employee);
  }

  void _discardChanges() {
    AppRouter.pop(context);
  }

  void _saveEmployee() {
    final employee = Employee(
      name: _nameEditingController.text.trim(),
      jobTitle: _jobTitleEditingController.text.trim(),
      fromDate: _fromDate,
      toDate: _toDate,
      createdAt: widget.employee == null ? DateTime.now().toIso8601String() : null,
      updatedAt: widget.employee != null ? DateTime.now().toIso8601String() : null,
    );

    //edit employee
    if (widget.employee != null) {
      //based on toData find out if the editing employee is current/past employee
      if (widget.employee?.toDate == null) {
        _isRemoveFromCurrent = _toDate != null;
      }
      _employeeCubit.updateEmployee(widget.index ?? -1, widget.employee!.id!, employee);
    }
    //save employee
    else {
      _employeeCubit.addEmployee(employee);
    }
  }

  void _listenStateChanges(context, state) {
    if (state is UpdatingEmployeeDetailsState) {
      ProgressDialog.show(context);
    }
    if (state is EmployeeDetailsAddedState) {
      ProgressDialog.dismiss(context);
      AppRouter.pop(context);
    }
    if (state is EmployeeDetailsUpdatedState) {
      ProgressDialog.dismiss(context);
      this.context.read<EmployeeListCubit>().updateEmployee(state.employee, _isRemoveFromCurrent, state.index);
      AppRouter.pop(context);
    }
    if (state is EmployeeDetailsDeletedState) {
      ProgressDialog.dismiss(context);
      AppRouter.pop(context);
    }
    if (state is EmployeeDetailsUpdateErrorState) {
      ProgressDialog.dismiss(context);
    }
  }
}
