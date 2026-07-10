import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:clevora/app/routes/app_pages.dart';
import 'package:clevora/app/routes/app_routes.dart';
import 'package:clevora/app/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:clevora/app/data/services/auth_service.dart';
import 'package:clevora/app/data/services/module_service.dart';
import 'package:clevora/app/data/services/quiz_service.dart';
import 'package:clevora/app/data/services/face_service.dart';
import 'package:clevora/app/data/services/attendance_service.dart';
import 'package:clevora/app/data/services/hasil_service.dart';
import 'package:clevora/app/data/services/profil_service.dart';
import 'package:clevora/app/data/providers/api_provider.dart';
import 'package:clevora/app/data/repositories/auth_repository.dart';
import 'package:clevora/app/data/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null);

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
  Get.lazyPut(() => ProfilService(), fenix: true);
  
  String initRoute = await getInitialRoute();
  runApp(ClevoraApp(initialRoute: initRoute));
}

Future<String> getInitialRoute() async {
  final secureStorage = const FlutterSecureStorage();
  final userString = await secureStorage.read(key: 'user');

  if (userString == null) {
    return AppPages.INITIAL; // Which is Routes.SPLASH
  }

  try {
    final userMap = jsonDecode(userString);
    final user = UserModel.fromJson(userMap);
    
    if (!user.isProfileComplete) {
      return Routes.COMPLETE_PROFILE;
    }
    
    return user.role == 'guru' ? Routes.TEACHER_MAIN : Routes.STUDENT_MAIN;
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
