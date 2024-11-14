import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Database accessor with lazy initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  // Database initialization with path and table creation
  Future<Database> _initializeDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'students.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            studentID TEXT,
            phone TEXT,
            email TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  // Insert a new student record
  Future<int> addStudent(Map<String, dynamic> student) async {
    Database db = await instance.database;
    return await db.insert('students', student);
  }

  // Retrieve all student records
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    Database db = await instance.database;
    return await db.query('students', orderBy: 'name ASC');
  }

  // Update an existing student record
  Future<int> updateStudent(Map<String, dynamic> student) async {
    Database db = await instance.database;
    String id = student['id'];
    return await db.update(
      'students',
      student,
      where: 'id = ?',
      whereArgs: [int.parse(id)],
    );
  }

  // Delete a student record by ID
  Future<int> deleteStudent(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database connection (if needed)
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
