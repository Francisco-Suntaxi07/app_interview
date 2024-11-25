import 'package:app_interview/model/employee_model.dart';
import 'package:app_interview/service/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class HomeViewModel  extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<EmployeeModel> _employees = [];

  Future<void> fetchEmployees() async {
    _employees = await _dbHelper.getAllEmployees();
    notifyListeners();
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    await _dbHelper.insertEmployee(employee);
    await fetchEmployees();
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    await _dbHelper.updateEmployee(employee);
    await fetchEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await _dbHelper.deleteEmployee(id);
    await fetchEmployees();
  }


  List<EmployeeModel> get employees => _employees;

}