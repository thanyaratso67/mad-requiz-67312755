// lib/models/my_transaction.dart
enum VaccinationType { income, expense }

class Vaccination {
  final int? id;
  final String vaccineName;
  final String hospital;
  final int doesNumber;
  final DateTime vaccinatedDate;
  final bool hasSideEffect;

  Vaccination({
    this.id,
    required this.vaccineName,
    required this.hospital,
    required this.doesNumber,
    required this.vaccinatedDate,
    required this.hasSideEffect
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ห้ามส่ง id ที่เป็น null เข้าไปใน UPDATE
      'vaccineName': vaccineName,
      'hospital': hospital,
      'doesNumber': doesNumber,
      'vaccinatedDate': vaccinatedDate.toIso8601String(),
      'hasSideEffect': hasSideEffect? 0 : 1, // เก็บเป็น 'income' หรือ 'expense'
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      id: map['id'] as int,
      vaccineName: map['vaccineName'] as String,
      hospital: map['hospital'] as String,
      doesNumber: (map['doesNumber'] as num).toInt(),
      vaccinatedDate: DateTime.parse(map['vaccinatedDate'] as String),
      hasSideEffect: map['hasSideEffect'] as bool,
    );
  }
}
