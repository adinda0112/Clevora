import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  String? selectedMapel;
  String? selectedKelas;
  DateTime selectedDate = DateTime.now();

  final List<String> mapelOptions = [
    'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Biologi', 'Fisika', 'Kimia'
  ];

  final List<String> kelasOptions = [
    'X IPA 1', 'X IPA 2', 'XI IPS 1', 'XII IPA 2'
  ];

  final List<Map<String, dynamic>> dummyStudents = [
    {'nama': 'Ahmad Fauzi', 'status': 'Hadir'},
    {'nama': 'Budi Santoso', 'status': 'Hadir'},
    {'nama': 'Siti Aminah', 'status': 'Alpa'},
    {'nama': 'Dewi Lestari', 'status': 'Sakit'},
    {'nama': 'Andi Wijaya', 'status': 'Izin'},
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      dummyStudents[index]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Absen Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur QR Scanner akan segera hadir!')));
            },
          ),
        ],
      ),
      body: selectedMapel != null && selectedKelas != null ? _buildStudentList() : _buildSelectionForm(),
    );
  }

  Widget _buildSelectionForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tanggal Presensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(8),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today, color: AppColors.grey500),
                ],
              ),
            ),
          ),
          const Gap(20),
          const Text('Pilih Kelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            hint: const Text('Pilih Kelas'),
            value: selectedKelas,
            items: kelasOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              setState(() {
                selectedKelas = val;
              });
            },
          ),
          const Gap(20),
          const Text('Mata Pelajaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            hint: const Text('Pilih Mata Pelajaran'),
            value: selectedMapel,
            items: mapelOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              setState(() {
                selectedMapel = val;
              });
            },
          ),
          const Gap(32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (selectedKelas != null && selectedMapel != null) ? () {
                setState(() {});
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Tampilkan Daftar Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedKelas = null;
                    selectedMapel = null;
                  });
                },
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  '$selectedKelas - $selectedMapel',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: dummyStudents.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final student = dummyStudents[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lightPurple,
                      child: Text(
                        student['nama'][0],
                        style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(student['nama'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Status: ${student['status']}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusButton('Hadir', Colors.green, index, student['status']),
                      _buildStatusButton('Alpa', Colors.red, index, student['status']),
                      _buildStatusButton('Sakit', Colors.amber, index, student['status']),
                      _buildStatusButton('Izin', Colors.blue, index, student['status']),
                    ],
                  ),
                  const Gap(8),
                ],
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.grey200)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar('Berhasil', 'Data absensi telah disimpan.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                _isToday() ? 'Simpan Absensi' : 'Update Presensi', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  bool _isToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
  }

  Widget _buildStatusButton(String label, Color color, int index, String currentStatus) {
    bool isSelected = label == currentStatus;
    return OutlinedButton(
      onPressed: () => _updateStatus(index, label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : color,
        backgroundColor: isSelected ? color : Colors.white,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(60, 36),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
