import 'package:get/get.dart';
import 'package:clevora/app/modules/student/student_qr_scanner/controllers/student_qr_scanner_controller.dart';

class StudentQrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentQrScannerController>(() => StudentQrScannerController());
  }
}
