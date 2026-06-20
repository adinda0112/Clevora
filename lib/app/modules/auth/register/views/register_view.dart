import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/auth/register/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Daftar Akun',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Ikuti langkah berikut untuk membuat akun',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gap(32),

              // Step Indicator
              Obx(
                () => _StepIndicator(currentStep: controller.currentStep.value),
              ),
              const Gap(32),

              // Step Content
              Obx(() {
                if (controller.currentStep.value == 0) {
                  return _Step0RoleSelection(controller: controller);
                } else {
                  return _Step1DataForm(controller: controller);
                }
              }),
              const Gap(32),

              // Navigation Buttons
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.nextStep(),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    controller.currentStep.value == 0
                                        ? 'Lanjut'
                                        : 'Daftar',
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.offNamed(Routes.LOGIN),
                        child: Text(
                          'Sudah punya akun? Login',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepDot(
          number: 1,
          isActive: currentStep >= 0,
          isComplete: currentStep > 0,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: currentStep > 0 ? AppColors.primaryPurple : AppColors.grey200,
          ),
        ),
        _StepDot(number: 2, isActive: currentStep >= 1, isComplete: false),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final bool isActive;
  final bool isComplete;

  const _StepDot({
    required this.number,
    required this.isActive,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive || isComplete ? AppColors.primaryPurple : AppColors.grey200,
      ),
      child: Center(
        child: isComplete
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                number.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isActive || isComplete
                      ? Colors.white
                      : AppColors.grey400,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _Step0RoleSelection extends StatelessWidget {
  final RegisterController controller;

  const _Step0RoleSelection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih Peran Anda', style: Theme.of(context).textTheme.titleLarge),
        const Gap(16),
        Obx(
          () => _BigRoleCard(
            icon: Icons.person_rounded,
            title: 'Guru',
            description: 'Kelola kelas dan buat materi pembelajaran',
            features: const ['Buat soal AI', 'Kelola siswa', 'Analisis nilai'],
            isSelected: controller.selectedRole.value == 'guru',
            onTap: () => controller.selectedRole.value = 'guru',
          ),
        ),
        const Gap(16),
        Obx(
          () => _BigRoleCard(
            icon: Icons.school_rounded,
            title: 'Siswa',
            description: 'Belajar dan kembangkan kemampuanmu',
            features: const [
              'Latihan soal',
              'Lihat nilai',
              'Analisis progress',
            ],
            isSelected: controller.selectedRole.value == 'siswa',
            onTap: () => controller.selectedRole.value = 'siswa',
          ),
        ),
      ],
    );
  }
}

class _BigRoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;

  const _BigRoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPurple : AppColors.grey50,
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? AppColors.primaryPurple : AppColors.grey400,
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? AppColors.primaryPurple : AppColors.grey900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.grey600),
                  ),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    children: features
                        .map(
                          (f) => Chip(
                            label: Text(
                              f,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.grey200),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 24),
          ],
        ),
      ),
    );
  }
}

class _Step1DataForm extends StatelessWidget {
  final RegisterController controller;

  const _Step1DataForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama
          Text('Nama Lengkap', style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          TextFormField(
            controller: controller.namaController,
            validator: (val) => val == null || val.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama lengkap',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.grey400),
            ),
          ),
          const Gap(20),

          // Email
          Text('Email', style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          TextFormField(
            controller: controller.emailController,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
              if (!GetUtils.isEmail(val)) return 'Format email tidak valid';
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'email@example.com',
              prefixIcon: Icon(Icons.mail_outline, color: AppColors.grey400),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),

          // Sekolah (Common for both roles)
          Text('Sekolah', style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          TextFormField(
            controller: controller.sekolahController,
            validator: (val) => val == null || val.trim().isEmpty ? 'Sekolah wajib diisi' : null,
            decoration: const InputDecoration(
              hintText: 'Nama Sekolah asal',
              prefixIcon: Icon(
                Icons.school_outlined,
                color: AppColors.grey400,
              ),
            ),
          ),
          const Gap(20),

          // NIP (conditional untuk guru) atau NISN, Kelas, Sekolah (conditional untuk siswa)
          Obx(() {
            if (controller.selectedRole.value == 'guru') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NIP', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  TextFormField(
                    controller: controller.nipController,
                    validator: (val) => val == null || val.trim().isEmpty ? 'NIP wajib diisi' : null,
                    decoration: const InputDecoration(
                      hintText: 'Nomor Induk Pegawai',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                  const Gap(20),
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
                    validator: (val) => val == null || val.trim().isEmpty ? 'NISN wajib diisi' : null,
                    decoration: const InputDecoration(
                      hintText: 'Nomor Induk Siswa Nasional',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: AppColors.grey400,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const Gap(20),
                  Text('Kelas', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedKelas.value,
                      items: controller.kelasOptions
                          .map(
                            (kelas) => DropdownMenuItem(value: kelas, child: Text('Kelas $kelas')),
                          )
                          .toList(),
                      onChanged: (value) => controller.selectedKelas.value = value ?? 'X',
                      decoration: const InputDecoration(
                        hintText: 'Pilih kelas',
                        prefixIcon: Icon(
                          Icons.class_outlined,
                          color: AppColors.grey400,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              );
            }
          }),

          // Mapel Dropdown (Guru)
          Obx(() {
            if (controller.selectedRole.value == 'guru') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mata Pelajaran', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.mapelOptions.map((mapel) {
                      return Obx(() {
                        final isSelected = controller.selectedMapel.contains(mapel);
                        return FilterChip(
                          label: Text(mapel),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedMapel.add(mapel);
                            } else {
                              controller.selectedMapel.remove(mapel);
                            }
                          },
                          selectedColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.primaryPurple,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primaryPurple : AppColors.grey700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      });
                    }).toList(),
                  ),
                  const Gap(20),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Jurusan Dropdown (Siswa)
          Obx(() {
            if (controller.selectedRole.value == 'siswa') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jurusan', style: Theme.of(context).textTheme.titleMedium),
                  const Gap(8),
                  DropdownButtonFormField<String>(
                    value: controller.selectedJurusan.value,
                    items: controller.jurusanOptions
                        .map(
                          (jurusan) =>
                              DropdownMenuItem(value: jurusan, child: Text(jurusan)),
                        )
                        .toList(),
                    onChanged: (value) => controller.selectedJurusan.value = value ?? '',
                    decoration: const InputDecoration(
                      hintText: 'Pilih jurusan',
                      prefixIcon: Icon(Icons.school_outlined, color: AppColors.grey400),
                    ),
                  ),
                  const Gap(20),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Password
          Text('Password', style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Password tidak boleh kosong';
                if (val.length < 8) return 'Minimal 8 karakter';
                return null;
              },
              decoration: InputDecoration(
                hintText: 'minimal 8 karakter',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.grey400,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePass.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey400,
                  ),
                  onPressed: () => controller.obscurePass.toggle(),
                ),
              ),
              obscureText: controller.obscurePass.value,
              onChanged: (value) => controller.checkPasswordStrength(value),
            ),
          ),
          const Gap(8),
          _PasswordStrengthBar(strength: controller.passwordStrength),
          const Gap(20),

          // Confirm Password
          Text(
            'Konfirmasi Password',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Konfirmasi password wajib diisi';
                if (val != controller.passwordController.text) return 'Password tidak cocok';
                return null;
              },
              decoration: InputDecoration(
                hintText: 'ulangi password',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.grey400,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirm.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.grey400,
                  ),
                  onPressed: () => controller.obscureConfirm.toggle(),
                ),
              ),
              obscureText: controller.obscureConfirm.value,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final RxDouble strength;

  const _PasswordStrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: index < (strength.value * 4)
                        ? _getStrengthColor(strength.value)
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const Gap(4),
          Text(
            _getStrengthText(strength.value),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStrengthColor(strength.value),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.3) return AppColors.red;
    if (strength <= 0.6) return AppColors.amber;
    return AppColors.teal;
  }

  String _getStrengthText(double strength) {
    if (strength == 0) return 'Kekuatan password: Lemah';
    if (strength <= 0.3) return 'Kekuatan password: Lemah';
    if (strength <= 0.6) return 'Kekuatan password: Sedang';
    if (strength < 1.0) return 'Kekuatan password: Kuat';
    return 'Kekuatan password: Sangat Kuat';
  }
}
