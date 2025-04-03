import '../../../core/navigation/model/route_arguments.dart';
import '../../../data/model/employee.dart';

class AddEmployeeRouteArguments extends RouteArguments {
  final Employee? employee;
  final int? index;
  AddEmployeeRouteArguments({this.employee, this.index});
}
