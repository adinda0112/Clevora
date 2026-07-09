import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/auth/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                24,
                40 + MediaQuery.of(context).padding.top,
                24,
                40,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B1753), Color(0xFF3C3489)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.login_rounded, color: Colors.white, size: 48),
                  const Gap(16),
                  Text(
                    'Masuk Akun',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Lanjutkan perjalanan belajarmu',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Form Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role Selector
                    Text(
                      'Pilih Peran',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(12),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.person_rounded,
                              label: 'Guru',
                              isSelected: controller.selectedRole.value == 'guru',
                              onTap: () => controller.selectedRole.value = 'guru',
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _RoleCard(
                              icon: Icons.school_rounded,
                              label: 'Siswa',
                              isSelected:
                                  controller.selectedRole.value == 'siswa',
                              onTap: () =>
                                  controller.selectedRole.value = 'siswa',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(32),

                    // Email Field
                    Text('Email', style: Theme.of(context).textTheme.titleMedium),
                    const Gap(8),
                    TextFormField(
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'masukkan@email.com',
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: AppColors.grey400,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Gap(20),

                    // Password Field
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 8) {
                            return 'Password minimal 8 karakter';
                          }
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
                      ),
                    ),
                    const Gap(16),

                    // Remember & Forgot Password
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: (value) =>
                                controller.rememberMe.value = value ?? false,
                            activeColor: AppColors.primaryPurple,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Ingat saya',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                          child: Text(
                            'Lupa kata sandi?',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),

                    // Login Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value || controller.isGoogleLoading.value
                              ? null
                              : () {
                                  if (controller.formKey.currentState?.validate() ?? false) {
                                    controller.login();
                                  }
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Masuk'),
                        ),
                      ),
                    ),
                    const Gap(20),

                    // Social Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.grey200)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau masuk dengan',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.grey200)),
                      ],
                    ),
                    const Gap(20),

                    // Social Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => _SocialButton(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Google',
                        isLoading: controller.isGoogleLoading.value,
                        onTap: controller.isLoading.value || controller.isGoogleLoading.value
                            ? null
                            : () => controller.handleGoogleSignIn(),
                      )),
                    ),
                    const Gap(24),

                    // Sign Up Link
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.offNamed(Routes.REGISTER),
                        child: RichText(
                          text: TextSpan(
                            text: 'Belum punya akun? ',
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: 'Daftar sekarang',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ), // End SingleChildScrollView
      ), // End Scaffold
    ); // End PopScope
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPurple : AppColors.grey50,
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryPurple : AppColors.grey400,
              size: 32,
            ),
            const Gap(8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? AppColors.primaryPurple : AppColors.grey600,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.grey800,
        side: const BorderSide(color: AppColors.grey300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryPurple,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: AppColors.primaryPurple),
                const Gap(10),
                Text(
                  'Masuk dengan $label',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey800,
                  ),
                )
              ],
            ),
    );
  }
}
