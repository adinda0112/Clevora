import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'dart:convert';

import 'package:clevora/app/modules/shared/profile/controllers/profile_controller.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 52, 137),
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Get.toNamed('/edit-profile');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Obx(() {
                    final user = controller.currentUser.value;
                    if (user != null && user.fotoProfilBase64 != null && user.fotoProfilBase64!.isNotEmpty) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(user.fotoProfilBase64!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Color(0xFF7F77DD),
                      ),
                    );
                  }),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.fullName.value,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => Text(
                            controller.role.value,
                            style: const TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            controller.email.value,
                            style: const TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(28),
              Obx(
                () => Text(
                  controller.role.value == 'Guru' ? 'Informasi Guru' : 'Informasi Siswa',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const Gap(14),
              Obx(() {
                final user = controller.currentUser.value;
                if (user == null) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (user.role == 'guru') ...[
                        _buildInfoRow('NIP', user.nip ?? '-'),
                        const Divider(height: 20),
                        _buildInfoRow('Mata Pelajaran', user.mapel ?? '-'),
                        const Divider(height: 20),
                        _buildInfoRow('Sekolah', user.sekolah ?? '-'),
                      ] else ...[
                        _buildInfoRow('NISN', user.nisn ?? '-'),
                        const Divider(height: 20),
                        _buildInfoRow('Kelas', user.kelas ?? '-'),
                        const Divider(height: 20),
                        _buildInfoRow('Jurusan', user.jurusan ?? '-'),
                        const Divider(height: 20),
                        _buildInfoRow('Sekolah', user.sekolah ?? '-'),
                      ],
                    ],
                  ),
                );
              }),
              const Gap(24),
              const Text(
                'Pengaturan Akun',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const Gap(14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Obx(
                  () => Column(
                    children: controller.settings
                        .map(
                          (item) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  if (item['action'] != null) {
                                    controller.handleSettingAction(item['action']);
                                  } else if (item['route'] != null && item['route'].toString().isNotEmpty) {
                                    Get.toNamed(item['route']);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] != null
                                      ? item['color'] as Color
                                      : const Color(0xFF7F77DD),
                                ),
                                title: Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: item['color'] != null
                                        ? item['color'] as Color
                                        : null,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Konfirmasi Logout',
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      titlePadding: const EdgeInsets.only(top: 24),
                      contentPadding: const EdgeInsets.all(24),
                      radius: 16,
                      content: const Column(
                        children: [
                          Icon(Icons.logout, size: 48, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            'Apakah Anda yakin ingin keluar dari aplikasi?',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      confirm: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          Get.back();
                          controller.logout();
                        },
                        child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      cancel: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
