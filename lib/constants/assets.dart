class Assets {
  static final AppIcons icons = AppIcons._();
  static final AppImages images = AppImages._();
}

class AppIcons {
  AppIcons._();

  static const String root = "assets/icons";
  final String arrowDownBlue = '$root/ic_arrow_down_blue.png';
  final String arrowLeftGrey = '$root/ic_arrow_left_grey.png';
  final String arrowRightGrey = '$root/ic_arrow_right_grey.png';
  final String arrowRightBlue = '$root/ic_arrow_right_blue.png';
  final String calendar = '$root/ic_calendar.png';
  final String delete = '$root/ic_delete.png';
  final String person = '$root/ic_person.png';
  final String plus = '$root/ic_plus.png';
  final String work = '$root/ic_work.png';
}

class AppImages {
  AppImages._();

  static const String root = "assets/images";
  final String noEmployeeRecords = '$root/no_employee_records.png';
}
