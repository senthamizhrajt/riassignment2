import '../../../core/extensions/string_extensions.dart';

class Employee {
  Employee({
    this.name,
    this.jobTitle,
    this.fromDate,
    this.createdAt,
    this.toDate,
    this.updatedAt,
    this.id,
  });

  final int? id;
  final String? name;
  final String? jobTitle;
  final String? fromDate;
  final String? toDate;
  final String? createdAt;
  final String? updatedAt;

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"],
      name: json["name"],
      jobTitle: json["jobTitle"],
      fromDate: json["fromDate"],
      toDate: json["toDate"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap = {
      "id": id,
      "name": name,
      "jobTitle": jobTitle,
      "fromDate": fromDate,
      "toDate": toDate,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
    if (id == null) jsonMap.remove('id');
    if (name.isNullOrTrimEmpty) jsonMap.remove('name');
    if (jobTitle.isNullOrTrimEmpty) jsonMap.remove('jobTitle');
    if (fromDate.isNullOrTrimEmpty) jsonMap.remove('fromDate');
    if (toDate.isNullOrTrimEmpty) jsonMap.remove('toDate');
    if (createdAt.isNullOrTrimEmpty) jsonMap.remove('createdAt');
    if (updatedAt.isNullOrTrimEmpty) jsonMap.remove('updatedAt');

    return jsonMap;
  }

  Employee copyWith({int? id, String? name, String? jobTitle, String? fromDate, String? toDate}) {
    return Employee(
      id: id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
