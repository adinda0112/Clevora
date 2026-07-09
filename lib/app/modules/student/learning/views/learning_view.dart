import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:clevora/app/modules/student/learning/controllers/learning_controller.dart';
import 'package:clevora/app/data/models/module_model.dart';
import 'package:clevora/app/modules/student/student_main/controllers/student_main_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LearningView extends GetView<LearningController> {
  const LearningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: const Text(
          'Materi Belajar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchModules(),
        child: Obx(() {
          if (controller.isLoading.value && controller.modules.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryPurple,
              ),
            );
          }

          if (controller.modules.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          size: 64,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      const Gap(20),
                      const Text(
                        'Belum Ada Materi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey900,
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        'Guru Anda belum mempublikasikan materi pelajaran untuk kelas ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.modules.length,
            itemBuilder: (context, index) {
              final module = controller.modules[index];
              return _buildModuleCard(context, module);
            },
          );
        }),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, ModuleModel module) {
    final date = module.createdAt;
    final formattedDate = date != null
        ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openModuleReader(context, module),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightTeal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        module.mapel ?? 'Materi',
                        style: const TextStyle(
                          color: Color(0xFF085041),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: AppColors.grey500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Gap(14),
                Text(
                  module.judul,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                  ),
                ),
                const Gap(6),
                Text(
                  module.deskripsi ?? 'Baca materi selengkapnya untuk mempelajari topik ini.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey600,
                  ),
                ),
                const Gap(16),
                const Divider(height: 1),
                const Gap(14),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.primaryPurple,
                    ),
                    const Gap(6),
                    Text(
                      module.guru?.nama ?? 'Guru Pengajar',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Mulai Belajar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.teal,
                      ),
                    ),
                    const Gap(4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openModuleReader(BuildContext context, ModuleModel module) {
    Get.to(
      const ModuleReaderPage(),
      arguments: module,
      transition: Transition.rightToLeft,
    );
  }
}

class ModuleReaderPage extends StatelessWidget {
  const ModuleReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ModuleModel module = Get.arguments as ModuleModel;
    final date = module.createdAt;
    final formattedDate = date != null
        ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
        : '-';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          module.judul,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            const Gap(8),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: AppColors.grey600),
                const Gap(4),
                Text(
                  module.guru?.nama ?? 'Guru Pengajar',
                  style: const TextStyle(fontSize: 13, color: AppColors.grey600),
                ),
                const Gap(12),
                const Icon(Icons.calendar_today, size: 12, color: AppColors.grey600),
                const Gap(4),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 13, color: AppColors.grey600),
                ),
              ],
            ),
            const Gap(16),
            const Divider(),
            const Gap(16),
            MarkdownBody(
              data: module.konten,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF374151),
                ),
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.grey900),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.grey900),
                h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.grey900),
              ),
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}
