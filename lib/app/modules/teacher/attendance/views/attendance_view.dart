import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/modules/teacher/attendance/controllers/attendance_controller.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.toNamed('/attendance-history'),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur QR Scanner akan segera hadir!')),
              );
            },
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
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (controller.selectedKelas.value.isNotEmpty && controller.selectedMapel.value.isNotEmpty && !controller.isLoading.value)
                  ? () => controller.loadSiswa()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2),
                    )
                  : const Text('Tampilkan Daftar Siswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )),
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
                onPressed: () => controller.showStudentList.value = false,
              ),
              const Gap(8),
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
                      width: 20, height: 20,
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
