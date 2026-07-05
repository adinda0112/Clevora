import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
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
  runApp(ClevoraApp(initialRoute: getInitialRoute()));
}

String getInitialRoute() {
  final storage = GetStorage();
  final token = storage.read('token');
  final userMap = storage.read('user');

  if (token == null || token.toString().isEmpty || userMap == null) {
    return AppPages.INITIAL; // Which is Routes.SPLASH
  }

  try {
    final role = userMap['role'] as String?;
    if (role == 'guru') {
      final nip = userMap['nip'] as String?;
      final sekolah = userMap['sekolah'] as String?;
      if (nip == null || nip.isEmpty || sekolah == null || sekolah.isEmpty) {
        return Routes.COMPLETE_PROFILE;
      }
      return Routes.TEACHER_MAIN;
    } else {
      final nisn = userMap['nisn'] as String?;
      final kelas = userMap['kelas'] as String?;
      final sekolah = userMap['sekolah'] as String?;
      if (nisn == null || nisn.isEmpty || kelas == null || kelas.isEmpty || sekolah == null || sekolah.isEmpty) {
        return Routes.COMPLETE_PROFILE;
      }
      return Routes.STUDENT_MAIN;
    }
  } catch (e) {
    return AppPages.INITIAL;
  }
}

class ClevoraApp extends StatelessWidget {
  final String initialRoute;
  const ClevoraApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clevora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
