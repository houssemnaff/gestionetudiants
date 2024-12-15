import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'students.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, class TEXT, phone TEXT, address TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> addStudent(Map<String, dynamic> student) async {
    final db = await _database();
    return db.insert('students', student);
  }

  static Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await _database();
    return db.query('students');
  }

  static Future<int> updateStudent(int id, Map<String, dynamic> student) async {
    final db = await _database();
    return db.update('students', student, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteStudent(int id) async {
    final db = await _database();
    return db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
