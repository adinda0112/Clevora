import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiResultController extends GetxController {
  final generateType = ''.obs;
  final topik = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      generateType.value = args['type'] ?? 'Modul';
      topik.value = args['topik'] ?? 'Topik Umum';
    }
  }

  void saveAndPublish() {
    Get.snackbar('Berhasil', '${generateType.value} berhasil disimpan dan dipublish!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEAF3DE),
      colorText: const Color(0xFF3B6D11),
      margin: const EdgeInsets.all(16),
    );
    // Back to AI Dashboard after short delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      Get.back();
    });
  }
}
