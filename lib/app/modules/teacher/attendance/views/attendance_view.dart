import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/modules/teacher/attendance/controllers/attendance_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Absen Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (controller.showStudentList.value) {
              controller.showStudentList.value = false;
            } else {
              Get.back();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed('/attendance-history'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.showStudentList.value) {
          return _buildStudentList();
        }
        return _buildSelectionForm();
      }),
    );
  }

  void _showQrDialog(BuildContext context) {
    controller.startQrSession();

    Get.dialog(
      PopScope(
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) controller.stopQrSession();
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.lightPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.qr_code_scanner, color: AppColors.primaryPurple, size: 28),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('QR Absensi Aktif',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
                              Obx(() => Text(
                                    '${controller.selectedKelas.value} · ${controller.selectedMapel.value}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.grey600),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  // QR Code
                  Obx(() {
                    if (controller.qrToken.value.isEmpty) {
                      return const SizedBox(
                        height: 230,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: QrImageView(
                        data: controller.qrToken.value,
                        version: QrVersions.auto,
                        size: 220.0,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.darkPurple,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    );
                  }),
                  const Gap(16),

                  // Countdown Timer
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: controller.qrCountdown.value <= 5
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: controller.qrCountdown.value <= 5
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                            const Gap(6),
                            Text(
                              'QR berubah dalam ${controller.qrCountdown.value} detik',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: controller.qrCountdown.value <= 5
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Gap(16),

                  // Live Attendance Count
                  Obx(() => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryPurple.withValues(alpha: 0.1), AppColors.primaryPurple.withValues(alpha: 0.05)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people_alt_outlined, color: AppColors.primaryPurple),
                            const Gap(10),
                            Text(
                              '${controller.liveAttendanceCount.value} Siswa',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                            ),
                            const Gap(6),
                            const Text('sudah absen', style: TextStyle(fontSize: 13, color: AppColors.grey600)),
                          ],
                        ),
                      )),

                  // Live attendance names
                  Obx(() {
                    if (controller.liveAttendanceList.isEmpty) return const SizedBox.shrink();
                    final recent = controller.liveAttendanceList.reversed.take(3).toList();
                    return Column(
                      children: [
                        const Gap(12),
                        ...recent.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                                  const Gap(8),
                                  Text(item['nama'] ?? '',
                                      style: const TextStyle(fontSize: 13, color: AppColors.grey800)),
                                ],
                              ),
                            )),
                      ],
                    );
                  }),
                  const Gap(20),

                  // Stop Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.stopQrSession();
                        Get.back();
                      },
                      icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
                      label: const Text('Hentikan Sesi QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
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
          Obx(() => InkWell(
                onTap: () => controller.pickDate(Get.context!),
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
                        '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.grey500),
                    ],
                  ),
                ),
              )),
          const Gap(20),
          const Text('Pilih Kelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(8),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                hint: const Text('Pilih Kelas'),
                value: controller.selectedKelas.value.isNotEmpty ? controller.selectedKelas.value : null,
                items: controller.kelasOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.selectedKelas.value = val;
                    controller.showStudentList.value = false;
                  }
                },
              )),
          const Gap(20),
          const Text('Mata Pelajaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(8),
          Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                hint: const Text('Pilih Mata Pelajaran'),
                value: controller.selectedMapel.value.isNotEmpty ? controller.selectedMapel.value : null,
                items: controller.mapelOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.selectedMapel.value = val;
                    controller.showStudentList.value = false;
                  }
                },
              )),
          const Gap(32),

          // Mode Buttons
          Row(
            children: [
              Expanded(
                child: Obx(() => SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: (controller.selectedKelas.value.isNotEmpty &&
                                controller.selectedMapel.value.isNotEmpty &&
                                !controller.isLoading.value)
                            ? () => controller.loadSiswa()
                            : null,
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2),
                              )
                            : const Icon(Icons.list_alt, color: Colors.white),
                        label: const Text('Input Manual', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )),
              ),
              const Gap(12),
              Expanded(
                child: Obx(() => SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: (controller.selectedKelas.value.isNotEmpty && controller.selectedMapel.value.isNotEmpty)
                            ? () => _showQrDialog(Get.context!)
                            : null,
                        icon: const Icon(Icons.qr_code_2, color: Colors.white),
                        label: const Text('QR Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    )),
              ),
            ],
          ),
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
              Obx(() => Expanded(
                    child: Text(
                      '${controller.selectedKelas.value} - ${controller.selectedMapel.value}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
          ),
        ),
        Obx(() => Expanded(
              child: controller.siswaList.isEmpty
                  ? const Center(child: Text('Tidak ada siswa di kelas ini'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.siswaList.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final siswa = controller.siswaList[index];
                        final status = siswa['status'] as String? ?? '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.lightPurple,
                                child: Text(
                                  (siswa['nama'] as String? ?? '?')[0],
                                  style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(siswa['nama'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(status.isNotEmpty ? 'Status: $status' : 'Belum diabsensi'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusButton('Hadir', Colors.green, index, status),
                                _buildStatusButton('Alpa', Colors.red, index, status),
                                _buildStatusButton('Sakit', Colors.amber, index, status),
                                _buildStatusButton('Izin', Colors.blue, index, status),
                              ],
                            ),
                            const Gap(8),
                          ],
                        );
                      },
                    ),
            )),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.grey200)),
          ),
          child: Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isSaving.value ? null : () => controller.save(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2),
                        )
                      : const Text('Simpan Absensi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String label, Color color, int index, String currentStatus) {
    final isSelected = label == currentStatus;
    return OutlinedButton(
      onPressed: () => controller.updateStatus(index, label),
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
