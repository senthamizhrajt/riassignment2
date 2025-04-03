import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../data/model/employee.dart';
import '../model/table.dart';

class EmployeeDBHelper {
  static Database? _database;

  Future<void> ensureInitialized() async {
    _database ??= await _initDatabase();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase({int? version}) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'assignment.db');
    final db = await openDatabase(path, version: version ?? 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    await _createEmployeesTable(db);
  }

  Future<void> _createEmployeesTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${Table.employees.name} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            jobTitle TEXT,
            fromDate TEXT,
            toDate TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
    ''');
  }

  Future<int> saveEmployee(Employee employee) async {
    final db = await database;
    final int insertId = await db.insert(
      Table.employees.name,
      employee.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return insertId;
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.transaction((txn) async {
      return txn.query(Table.employees.name, orderBy: 'id DESC');
    });

    return maps.map(Employee.fromJson).toList();
  }

  Future<List<Employee>> getCurrentEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Table.employees.name,
      where: 'toDate IS NULL',
      orderBy: 'createdAt DESC',
    );
    return maps.map(Employee.fromJson).toList();
  }

  Future<List<Employee>> getPastEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Table.employees.name,
      where: 'toDate IS NOT NULL',
      orderBy: 'createdAt DESC',
    );
    return maps.map(Employee.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> getEmployeeById(int employeeId) async {
    final db = await database;
    return db.transaction((transaction) async {
      return transaction.query(Table.employees.name, where: 'id = ?', whereArgs: [employeeId], orderBy: 'id DESC');
    });
  }

  Future<int> updateEmployee(int employeeId, Employee employee) async {
    final db = await database;
    final int updateCount = await db.update(
      Table.employees.name,
      employee.toJson(),
      where: 'id = ?',
      whereArgs: [employeeId],
    );
    return updateCount;
  }

  Future<int> deleteEmployee(int employeeId) async {
    final db = await database;
    final int updateCount = await db.delete(Table.employees.name, where: 'id = ?', whereArgs: [employeeId]);
    return updateCount;
  }

  Future<void> deleteTables() async {
    final db = await database;
    await db.delete(Table.employees.name);
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
