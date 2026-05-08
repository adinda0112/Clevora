import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../module/controllers/module_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../../result/controllers/result_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ModuleController>(() => ModuleController());
    Get.lazyPut<QuizController>(() => QuizController());
    Get.lazyPut<ResultController>(() => ResultController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
