import 'package:get/get.dart';
import '../controllers/module_controller.dart';

class ModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleController>(() => ModuleController());
  }
}
