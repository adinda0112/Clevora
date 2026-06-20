import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/services/module_service.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/face_service.dart';
import 'package:clevora/app/data/services/attendance_service.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/data/repositories/auth_repository.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  Get.put(ApiProvider(), permanent: true);
  Get.put(AuthRepository(Get.find<ApiProvider>()), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.lazyPut(() => ModuleService(), fenix: true);
  Get.lazyPut(() => QuizService(), fenix: true);
  Get.lazyPut(() => FaceService(), fenix: true);
  Get.lazyPut(() => AttendanceService(), fenix: true);
  Get.lazyPut(() => HasilService(), fenix: true);
  runApp(const ClevoraApp());
}

class ClevoraApp extends StatelessWidget {
  const ClevoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clevora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
