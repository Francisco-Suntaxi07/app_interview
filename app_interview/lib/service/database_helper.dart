import 'package:app_interview/model/employee_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'employees.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            apellido TEXT,
            cedula TEXT,
            cargo TEXT,
            area TEXT,
            firma TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertEmployee(EmployeeModel employee) async {
    final db = await database;
    return await db.insert('employees', employee.toMap());
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) => EmployeeModel.fromMap(maps[i]));
  }

  Future<int> updateEmployee(EmployeeModel employee) async {
    final db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
