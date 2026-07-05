import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/attendance_service.dart';
import 'package:clevora/app/data/services/auth_service.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();
  final AuthService _authService = Get.find<AuthService>();

  final selectedMapel = RxString('');
  final selectedKelas = RxString('');
  final selectedDate = DateTime.now().obs;
  final showStudentList = false.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isHistoryEmpty = false.obs;

  final kelasOptions = <String>[].obs;
  final mapelOptions = <String>[].obs;

  final siswaList = <Map<String, dynamic>>[].obs;

  // --- QR Dynamic ---
  final qrToken = ''.obs;
  final qrCountdown = 0.obs;
  final isQrActive = false.obs;
  Timer? _qrTimer;
  Timer? _countdownTimer;

  // --- Real-time Socket ---
  final liveAttendanceCount = 0.obs;
  final liveAttendanceList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTeacherData();
    kelasOptions.value = [
      'X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2',
      'X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2',
    ];
  }

  @override
  void onClose() {
    stopQrSession();
    _attendanceService.disconnectSocket();
    super.onClose();
  }

  void _loadTeacherData() {
    final user = _authService.currentUser.value;
    if (user != null && user.mapel != null && user.mapel!.isNotEmpty) {
      mapelOptions.value = user.mapel!.split(',').map((e) => e.trim()).toList();
    }
  }

  void setKelasOptions(List<String> options) {
    kelasOptions.value = options;
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      showStudentList.value = false;
    }
  }

  Future<void> loadSiswa() async {
    if (selectedKelas.value.isEmpty) return;

    isLoading.value = true;
    try {
      final data = await _attendanceService.getAttendance(
        kelas: selectedKelas.value,
        bulan: selectedDate.value.month,
        tahun: selectedDate.value.year,
      );

      final siswa = data['siswa'] as List<dynamic>? ?? [];
      final logs = data['logs'] as List<dynamic>? ?? [];

      siswaList.value = siswa.map((s) {
        final sJson = s as Map<String, dynamic>;
        final log = logs.cast<Map<String, dynamic>>().firstWhereOrNull(
          (l) => (l['siswa'] is Map ? l['siswa']['_id'] : l['siswa']) == sJson['_id'] &&
              _isSameDate(DateTime.parse(l['tanggal']), selectedDate.value),
        );

        return {
          '_id': sJson['_id'],
          'nama': sJson['nama'],
          'status': log != null ? _mapStatus(log['status']) : null,
        };
      }).toList();

      showStudentList.value = true;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(int index, String status) {
    siswaList[index] = {
      ...siswaList[index],
      'status': status,
    };
    siswaList.refresh();
  }

  Future<void> save() async {
    if (selectedKelas.value.isEmpty) return;

    isSaving.value = true;
    try {
      final records = siswaList.where((s) => s['status'] != null && s['_id'] != null).map((s) {
        return {
          'siswaId': s['_id'],
          'status': _reverseMapStatus(s['status']),
        };
      }).toList();

      final success = await _attendanceService.recordAttendance(
        records: records,
        tanggal: '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}',
        kelas: selectedKelas.value,
        mapel: selectedMapel.value.isNotEmpty ? selectedMapel.value : null,
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Data absensi telah disimpan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
      } else {
        throw 'Gagal menyimpan absensi';
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // === QR Dynamic (JWT 30s) ===
  Future<void> startQrSession() async {
    if (selectedKelas.value.isEmpty || selectedMapel.value.isEmpty) return;

    isQrActive.value = true;
    liveAttendanceCount.value = 0;
    liveAttendanceList.clear();

    // Connect Socket.io for real-time updates
    _attendanceService.initSocket(selectedKelas.value, (data) {
      liveAttendanceCount.value++;
      if (data is Map<String, dynamic>) {
        final nama = data['siswa']?['nama'] ?? 'Siswa';
        liveAttendanceList.add({'nama': nama, 'waktu': DateTime.now().toString()});
      }
    });

    await _generateNewQr();

    // Auto-refresh QR every 30 seconds
    _qrTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (isQrActive.value) {
        await _generateNewQr();
      }
    });
  }

  Future<void> _generateNewQr() async {
    try {
      final token = await _attendanceService.generateQr(
        kelas: selectedKelas.value,
        mapel: selectedMapel.value,
        tanggal: '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}',
      );
      qrToken.value = token;
      qrCountdown.value = 30;

      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (qrCountdown.value > 0) {
          qrCountdown.value--;
        } else {
          timer.cancel();
        }
      });
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal membuat QR: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
    }
  }

  void stopQrSession() {
    isQrActive.value = false;
    _qrTimer?.cancel();
    _qrTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    qrToken.value = '';
    qrCountdown.value = 0;
    _attendanceService.disconnectSocket();
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _mapStatus(String code) {
    switch (code) {
      case 'H': return 'Hadir';
      case 'S': return 'Sakit';
      case 'I': return 'Izin';
      case 'A': return 'Alpa';
      default: return 'Hadir';
    }
  }

  String _reverseMapStatus(String label) {
    switch (label) {
      case 'Hadir': return 'H';
      case 'Sakit': return 'S';
      case 'Izin': return 'I';
      case 'Alpa': return 'A';
      default: return 'H';
    }
  }
}
