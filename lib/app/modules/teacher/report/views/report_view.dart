import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/teacher/report/controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text('Laporan Nilai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.selectedKelas.value != null && controller.selectedMapel.value != null) {
          return _buildStudentList();
        }
        if (controller.selectedKelas.value != null) {
          return _buildMapelSelection();
        }
        return _buildJurusanKelasSelection();
      }),
    );
  }

  Widget _buildJurusanKelasSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Jurusan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
          const Gap(12),
          Row(
            children: [
              _jurusanCard('IPA'),
              const Gap(16),
              _jurusanCard('IPS'),
            ],
          ),
          const Gap(32),
          Obx(() {
            final jurusan = controller.selectedJurusan.value;
            if (jurusan == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daftar Kelas $jurusan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple)),
                const Gap(16),
                ...controller.kelasByJurusan[jurusan]!.map((kelas) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(kelas, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.primaryPurple),
                    onTap: () => controller.selectKelas(kelas),
                  ),
                )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _jurusanCard(String title) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedJurusan.value == title;
        return GestureDetector(
          onTap: () => controller.selectJurusan(title),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryPurple : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? AppColors.primaryPurple : AppColors.grey200),
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primaryPurple.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.grey600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMapelSelection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.backFromKelas,
              ),
              const Gap(8),
              Obx(() => Text(
                'Kelas ${controller.selectedKelas.value}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
              )),
            ],
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.mapelList.length,
            itemBuilder: (context, index) {
              final mapel = controller.mapelList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(mapel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.primaryPurple),
                  onTap: () => controller.selectMapel(mapel),
                ),
              );
            },
          )),
        ),
      ],
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
                onPressed: controller.backFromMapel,
              ),
              const Gap(8),
              Expanded(
                child: Obx(() => Text(
                  'Nilai ${controller.selectedMapel.value}\nKelas ${controller.selectedKelas.value}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkPurple),
                )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final names = controller.studentNames;
            if (names.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
                    const Gap(16),
                    const Text('Belum ada data nilai untuk kelas ini',
                      style: TextStyle(color: AppColors.grey600, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: names.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final nama = names[index];
                final results = controller.resultsForStudent(nama);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.lightPurple,
                    child: Text(
                      nama[0],
                      style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(nama, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: results.map((r) => _buildScoreBadge(r.kuisJudul, r.nilai)).toList(),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(String label, int score) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.grey600)),
        const Gap(2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: score >= 80 ? const Color(0xFFEAF3DE) : AppColors.lightAmber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 12,
              color: score >= 80 ? const Color(0xFF3B6D11) : const Color(0xFF633806),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
