// lib/providers/transaction_provider.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/my_transaction.dart';

class VaccinationProvider with ChangeNotifier {
  static const String _dbName = 'Vaccination.db';
  static const String _tableName = 'Vaccination';
  Database? _database;
  List<Vaccination> _vaccination = [];

  VaccinationProvider() {
    fetchAndSetVaccination(); // โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  List<Vaccination> get vaccination => [..._vaccination];

  // กระบวนการที่ 2: การสร้างฐานข้อมูล
  Future<void> _initDatabase() async {
    if (_database != null) return;
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          print('Creating table $_tableName...');
          return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'vaccineName TEXT,'
            'hospital TEXT,'
            'doesNumber REAL,' 
            'vaccinatedDate TEXT,' 
            'hasSideEffect TEXT)',
          );
        },
      );
      print('Database initialized at $path');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // กระบวนการที่ 3: การ Insert
  Future<void> addVaccination(
    String vaccineName,
    String hospital,
    int doesNumber,
    DateTime vaccinatedDate,
    bool hasSideEffect,
  ) async {
    await _initDatabase(); // ตรวจสอบว่า DB พร้อมใช้งาน
    if (_database == null) return;

    final newVaccination = Vaccination(
      vaccineName: vaccineName,
      hospital: hospital,
      doesNumber: doesNumber,
      vaccinatedDate: vaccinatedDate,
      hasSideEffect: hasSideEffect
    );

    final id = await _database!.insert(_tableName, newVaccination.toMap());
    print('Inserted vaccination with id: $id');
    await fetchAndSetVaccination();
  }

  // กระบวนการที่ 4: การ Read
  Future<void> fetchAndSetVaccination() async {
    await _initDatabase();
    if (_database == null) return;

    final dataList = await _database!.query(_tableName, orderBy: 'date DESC');
    _vaccination = dataList.map((item) => Vaccination.fromMap(item)).toList();
    print('Fetched ${_vaccination.length} vaccination.');
    notifyListeners(); // แจ้ง UI ให้วาดใหม่
  }

  // กระบวนการที่ 5: การ Update
  Future<void> updateVaccination(int id, Vaccination newVaccination) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.update(
      _tableName,
      newVaccination.toMap(), // toMap() ไม่ส่ง id ที่เป็น null จึงไม่ไปเปลี่ยนคีย์หลัก
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetVaccination();
  }

  // กระบวนการที่ 6: การ Delete
  Future<void> deleteVaccination(int id) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetVaccination();
  }
}
