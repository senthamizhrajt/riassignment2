import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/routes/arguments/add_employee_route_arguments.dart';
import '../../../common/routes/routes.dart';
import '../../../common/utils/date_utils.dart';
import '../../../common/widgets/app_snackbar.dart';
import '../../../common/widgets/asset_graphic.dart';
import '../../../common/widgets/safe_padding.dart';
import '../../../constants/assets.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/model/employee.dart';
import '../../../database/sqlite/employee_db_helper.dart';
import '../cubits/employee_cubit.dart';
import '../cubits/employee_list_cubit.dart';
import '../states/employee_list_state.dart';
import '../states/employee_state.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      appBar: AppBar(title: const Text('Employee List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.push(context, Routes.addEmployee);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: AssetGraphic(path: Assets.icons.plus, height: 18),
      ),
      body: Stack(
        children: [
          BlocListener<EmployeeCubit, EmployeeState>(listener: _listenStateChanges, child: const SizedBox.shrink()),
          BlocBuilder<EmployeeListCubit, EmployeeListState>(
            buildWhen: (previous, current) => current is EmployeesLoadedState,
            builder: (context, state) {
              if (state.employees.isEmpty && state.pastEmployees.isEmpty) {
                return Animate(
                  effects: const [FadeEffect()],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: AssetGraphic(path: Assets.images.noEmployeeRecords, height: 244)),
                      const SafePadding(extraHeight: kToolbarHeight),
                    ],
                  ),
                );
              }
              return CustomScrollView(
                slivers: [
                  _buildHeader('Current Employees'),
                  SliverToBoxAdapter(
                    child: BlocBuilder<EmployeeListCubit, EmployeeListState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        return _buildEmployeeList(state.employees);
                      },
                    ),
                  ),
                  _buildHeader('Previous Employees'),
                  SliverToBoxAdapter(
                    child: BlocBuilder<EmployeeListCubit, EmployeeListState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        return _buildEmployeeList(state.pastEmployees);
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text('Swipe left to delete', style: TextStyle(color: Color(0xFF949C9E))),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SafePadding(extraHeight: 100)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: SizedBox.square(dimension: 32, child: CircularProgressIndicator())), SafePadding()],
    );
  }

  Widget _buildError(String message) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(message, textAlign: TextAlign.center),
    );
  }

  Widget _buildEmployeeList(List<Employee> employees) {
    if (employees.isEmpty) {
      return const ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        tileColor: Colors.white,
        title: Text('No employee records found', textAlign: TextAlign.center),
        titleAlignment: ListTileTitleAlignment.center,
      );
    }
    return Animate(
      effects: const [FadeEffect()],
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const Divider(height: 1);
          },
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Dismissible(
              key: Key(employee.id!.toString()),
              background: Container(
                color: const Color(0xFFF34642),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AssetGraphic(path: Assets.icons.delete, width: 24),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                context.read<EmployeeCubit>().deleteEmployee(employee, index);
              },
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {
                    final args = AddEmployeeRouteArguments(employee: employee, index: index);
                    AppRouter.push(context, Routes.addEmployee, arguments: args);
                  },
                  title: Text(
                    employee.name ?? 'Unknown',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        employee.jobTitle ?? 'Unknown',
                        style: const TextStyle(fontSize: 14, color: AppColors.secondaryTextColor),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${employee.toDate == null ? 'From ' : ''}${employee.fromDate != null ? DateTimeUtils.formatIsoDate(employee.fromDate!) : '-'}',
                            style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextColor),
                          ),
                          if (employee.toDate != null)
                            Text(
                              ' - ${employee.toDate != null ? DateTimeUtils.formatIsoDate(employee.toDate!) : '-'}',
                              style: const TextStyle(fontSize: 12, color: AppColors.secondaryTextColor),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: employees.length,
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: const TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _listenStateChanges(context, state) async {
    if (state is EmployeeDetailsAddedState) {
      await this.context.read<EmployeeListCubit>().addEmployee(state.employee, state.index);
      if (state.notify) {
        await Future.delayed(const Duration(milliseconds: 250)); //added delay to match with screen transition
        AppSnackBar.show(context, 'Employee data has been saved');
      }
    }
    if (state is EmployeeDetailsUpdatedState) {
      await Future.delayed(const Duration(milliseconds: 250)); //added delay to match with screen transition
      AppSnackBar.show(context, 'Employee data has been updated');
    }
    if (state is EmployeeDetailsDeletedState) {
      if (mounted) {
        await this.context.read<EmployeeListCubit>().deleteEmployee(state.index, state.employee);
      }
      await Future.delayed(const Duration(milliseconds: 250)); //added delay to match with screen transition
      AppSnackBar.show(
        context,
        'Employee data has been deleted',
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            this.context.read<EmployeeCubit>().undoDelete(state.employee);
          },
        ),
      );
    }
  }
}
