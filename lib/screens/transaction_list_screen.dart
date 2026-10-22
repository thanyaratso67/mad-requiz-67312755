// lib/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/my_transaction.dart';

class VaccinationListScreen extends StatelessWidget {
  const VaccinationListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('การฉีดวัคซีน')),
      body: Consumer<VaccinationProvider>(
        builder: (context, provider, child) =>
            provider.vaccination.isEmpty
                ? const Center(child: Text('ไม่มีรายการ'))
                : ListView.builder(
                    itemCount: provider.vaccination.length,
                    itemBuilder: (ctx, i) {
                      final v = provider.vaccination[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(v.hasSideEffect == VaccinationType.income ? 'มี' : 'ไม่มี'),
                        ),
                        title: Text(v.vaccineName),
                        subtitle: Text(DateFormat.yMMMd().format(v.vaccinatedDate)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${v.doesNumber.toStringAsFixed(0)} ',
                              style: TextStyle(
                                color: v.hasSideEffect == VaccinationType.income ? Colors.green : Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                // เรียกเมธอด delete
                                context.read<VaccinationProvider>().deleteVaccination(v.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      // ปุ่มเพิ่มรายการตัวอย่างชั่วคราว จนกว่าจะสร้างหน้าฟอร์มในการบ้าน
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<VaccinationProvider>().addVaccination(
          'วัคซีนตัวอย่าง',
          'โรงพยาบาลตัวอย่าง',
          1,
          DateTime.now(),
          true,
        ),
       child: const Icon(Icons.add),
      ),
    );
  }
}

class Vaccination extends StatefulWidget {
  const Vaccination({super.key});
  @override
  State<Vaccination> createState() => _VaccinationState();
}

class _VaccinationState extends State<Vaccination> {
  //final dbHelper = DatabaseHelper.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    // คืนหน่วยความจำของ controller เมื่อหน้าจอถูกทำลาย (บทที่ 8)
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

 void _initState() {
    super.initState();
    // _queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite C.R.U.D. Lab')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initState,
              child: const Text('Insert Note'),
            ),
            // พื้นที่สำหรับแสดงผล (จะเพิ่มในขั้นตอนถัดไป)
          ],
        ),
      ),
    );
  }
}
