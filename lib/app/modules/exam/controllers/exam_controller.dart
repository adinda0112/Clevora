import 'package:get/get.dart';

class ExamController extends GetxController {
  final currentIndex = 0.obs;
  final timer = (30 * 60).obs;

  final questions = <Map<String, dynamic>>[
    {
      'question': 'Manakah dari berikut ini yang merupakan bahasa pemrograman untuk pengembangan web sisi klien?',
      'options': [
        {'letter': 'A', 'text': 'Python'},
        {'letter': 'B', 'text': 'Java'},
        {'letter': 'C', 'text': 'JavaScript'},
        {'letter': 'D', 'text': 'C++'},
      ],
      'selected': RxnString(),
    },
    {
      'question': 'Protokol apa yang digunakan untuk mengirim email?',
      'options': [
        {'letter': 'A', 'text': 'HTTP'},
        {'letter': 'B', 'text': 'FTP'},
        {'letter': 'C', 'text': 'SMTP'},
        {'letter': 'D', 'text': 'SSH'},
      ],
      'selected': RxnString(),
    },
  ].obs;

  void selectOption(String option) {
    questions[currentIndex.value]['selected'].value = option;
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    } else {
      Get.offNamed('/result');
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
}
