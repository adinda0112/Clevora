import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B1753), Color(0xFF3C3489)],
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.school_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ).animate().scale(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.elasticOut,
                        ),
                        const Gap(24),
                        Text(
                              'Clevora',
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 400))
                            .slideY(begin: 0.3, end: 0),
                        const Gap(8),
                        Text(
                              'Platform Pembelajaran Cerdas',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                            )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 400))
                            .slideY(begin: 0.3, end: 0),
                        const Gap(16),
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                '✦ Powered by AI',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: const Duration(milliseconds: 500))
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                ),
                Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Belajar Lebih Cerdas',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Gap(12),
                          Text(
                            'Platform pembelajaran dengan teknologi AI terdepan untuk membantu Anda mencapai prestasi maksimal',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Gap(24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _FeatureChip(label: 'AI Generate'),
                              _FeatureChip(label: 'Kurikulum Merdeka'),
                              _FeatureChip(label: 'Infografis'),
                              _FeatureChip(label: 'Export PDF'),
                            ],
                          ),
                          const Gap(32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => controller.goToRegister(),
                              child: const Text('Mulai sekarang'),
                            ),
                          ),
                          const Gap(12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => controller.goToLogin(),
                              child: const Text('Saya sudah punya akun'),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: const Duration(milliseconds: 500),
                    )
                    .fadeIn(duration: const Duration(milliseconds: 400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.purple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
