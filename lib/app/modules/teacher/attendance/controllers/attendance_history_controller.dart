import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/data/services/attendance_service.dart';

class AttendanceHistoryController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final sessions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final selectedKelas = RxString('');
  final selectedBulan = DateTime.now().month.obs;
  final selectedTahun = DateTime.now().year.obs;

  final kelasOptions = <String>[].obs;
  final bulanOptions = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  @override
  void onInit() {
    super.onInit();
    kelasOptions.value = [
      'X IPA 1', 'X IPA 2', 'XI IPA 1', 'XI IPA 2', 'XII IPA 1', 'XII IPA 2',
      'X IPS 1', 'X IPS 2', 'XI IPS 1', 'XI IPS 2', 'XII IPS 1', 'XII IPS 2',
    ];
  }

  void setKelasOptions(List<String> options) {
    kelasOptions.value = options;
  }

  Future<void> loadHistory() async {
    if (selectedKelas.value.isEmpty) return;

    isLoading.value = true;
    try {
      final data = await _attendanceService.getAttendance(
        kelas: selectedKelas.value,
        bulan: selectedBulan.value,
        tahun: selectedTahun.value,
      );

      final logs = data['logs'] as List<dynamic>? ?? [];

      final grouped = <String, List<Map<String, dynamic>>>{};
      for (final log in logs) {
        final l = log as Map<String, dynamic>;
        final date = l['tanggal']?.toString().substring(0, 10) ?? '';
        final mapel = l['mapel']?.toString() ?? '';
        final key = '$date|$mapel';

        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(l);
      }

      final List<Map<String, dynamic>> result = [];
      for (final entry in grouped.entries) {
        final parts = entry.key.split('|');
        final dateStr = parts[0];
        final mapel = parts[1];
        final logsGroup = entry.value;

        int hadir = 0, alpa = 0, izin = 0, sakit = 0;
        for (final l in logsGroup) {
          switch (l['status']) {
            case 'H': hadir++; break;
            case 'A': alpa++; break;
            case 'I': izin++; break;
            case 'S': sakit++; break;
          }
        }

        result.add({
          'date': _formatDate(dateStr),
          'dateRaw': dateStr,
          'kelas': logsGroup.first['kelas'] ?? selectedKelas.value,
          'mapel': mapel.isNotEmpty ? mapel : '(tanpa mapel)',
          'students': logsGroup.map((l) {
            final s = l['siswa'];
            return {
              'nama': s is Map ? (s['nama'] ?? '') : '',
              'status': _mapStatus(l['status']),
            };
          }).toList(),
          'stats': {'hadir': hadir, 'alpa': alpa, 'izin': izin, 'sakit': sakit},
        });
      }

      result.sort((a, b) => b['dateRaw'].compareTo(a['dateRaw']));
      sessions.value = result;
    } catch (e) {
      sessions.value = [];
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

  Future<void> updateSessionStudents(Map<String, dynamic> session, List<Map<String, dynamic>> updatedStudents) async {
    try {
      final records = updatedStudents.where((s) => s['_id'] != null).map((s) {
        return {
          'siswaId': s['_id'],
          'status': _reverseMapStatus(s['status']),
        };
      }).toList();

      final success = await _attendanceService.recordAttendance(
        records: records,
        tanggal: session['dateRaw'],
        kelas: session['kelas'],
        mapel: session['mapel'] != '(tanpa mapel)' ? session['mapel'] : null,
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Data presensi berhasil diperbarui.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        loadHistory();
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  String _formatDate(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length != 3) return isoDate;
    final monthNames = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final day = int.parse(parts[2]);
    final month = int.parse(parts[1]);
    final year = parts[0];
    return '$day ${monthNames[month]} $year';
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
