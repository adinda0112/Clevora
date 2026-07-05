import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clevora/app/modules/auth/complete_profile/controllers/complete_profile_controller.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lengkapi Profil', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tinggal Satu Langkah Lagi!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                  ),
                  const Gap(8),
                  Text(
                    'Harap lengkapi profil Anda sebelum mulai menggunakan aplikasi.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(32),

                  // Nama Lengkap (Common for both roles)
                  Text('Nama Lengkap', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  TextFormField(
                    controller: controller.namaLengkapController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Nama Lengkap wajib diisi';
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.grey400),
                    ),
                  ),
                  const Gap(20),

                  // Sekolah (Common for both roles)
                  Text('Sekolah', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  TextFormField(
                    controller: controller.sekolahController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Sekolah wajib diisi';
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nama Sekolah asal',
                      prefixIcon: Icon(Icons.school_outlined, color: AppColors.grey400),
                    ),
                  ),
                  const Gap(20),
                  Obx(() {
                    if (controller.role.value == 'guru') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NIP', style: Theme.of(context).textTheme.titleMedium),
                          const Gap(8),
                          TextFormField(
                            controller: controller.nipController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'NIP wajib diisi';
                              if (val.trim().length != 18) return 'NIP harus terdiri dari 18 angka';
                              if (int.tryParse(val.trim()) == null) return 'NIP hanya boleh berisi angka';
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Nomor Induk Pegawai (18 angka)',
                              prefixIcon: Icon(Icons.badge_outlined, color: AppColors.grey400),
                            ),
                          ),
                          const Gap(20),
                          Text('Mata Pelajaran', style: Theme.of(context).textTheme.titleMedium),
                          const Gap(8),
                          DropdownButtonFormField<String>(
                            value: controller.selectedMapel.value,
                            items: controller.mapelOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (v) => controller.selectedMapel.value = v ?? '',
                            decoration: const InputDecoration(
                              hintText: 'Pilih mata pelajaran',
                              prefixIcon: Icon(Icons.book_outlined, color: AppColors.grey400),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NISN', style: Theme.of(context).textTheme.titleMedium),
                          const Gap(8),
                          TextFormField(
                            controller: controller.nisnController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'NISN wajib diisi';
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Nomor Induk Siswa Nasional',
                              prefixIcon: Icon(Icons.badge_outlined, color: AppColors.grey400),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const Gap(20),
                          Text('Kelas', style: Theme.of(context).textTheme.titleMedium),
                          const Gap(8),
                          DropdownButtonFormField<String>(
                            value: controller.selectedKelas.value,
                            items: controller.kelasOptions.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                            onChanged: (v) => controller.selectedKelas.value = v ?? 'X IPA 1',
                            decoration: const InputDecoration(
                              hintText: 'Pilih kelas',
                              prefixIcon: Icon(Icons.class_outlined, color: AppColors.grey400),
                            ),
                          ),
                        ],
                      );
                    }
                  }),

                  const Gap(40),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () {
                          if (controller.formKey.currentState?.validate() ?? false) {
                            controller.saveProfile();
                          }
                        },
                        child: controller.isLoading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Simpan Profil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
