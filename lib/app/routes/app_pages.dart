// ignore_for_file: constant_identifier_names, deprecated_member_use
import 'package:get/get.dart';
import 'app_routes.dart';

// Auth
import 'package:clevora/app/modules/auth/splash/bindings/splash_binding.dart';
import 'package:clevora/app/modules/auth/splash/views/splash_view.dart';
import 'package:clevora/app/modules/auth/login/bindings/login_binding.dart';
import 'package:clevora/app/modules/auth/login/views/login_view.dart';
import 'package:clevora/app/modules/auth/register/bindings/register_binding.dart';
import 'package:clevora/app/modules/auth/register/views/register_view.dart';
import 'package:clevora/app/modules/auth/otp/bindings/otp_binding.dart';
import 'package:clevora/app/modules/auth/otp/views/otp_view.dart';
import 'package:clevora/app/modules/auth/complete_profile/bindings/complete_profile_binding.dart';
import 'package:clevora/app/modules/auth/complete_profile/views/complete_profile_view.dart';

// Teacher
import 'package:clevora/app/modules/teacher/teacher_main/bindings/teacher_main_binding.dart';
import 'package:clevora/app/modules/teacher/teacher_main/views/teacher_main_view.dart';
import 'package:clevora/app/modules/teacher/dashboard/bindings/teacher_home_binding.dart';
import 'package:clevora/app/modules/teacher/dashboard/views/teacher_home_view.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/quiz_management_view.dart';
import 'package:clevora/app/modules/teacher/quiz_management/views/manual_quiz_questions_view.dart';
import 'package:clevora/app/modules/teacher/report/views/report_view.dart';
import 'package:clevora/app/modules/teacher/report/bindings/report_binding.dart';
import 'package:clevora/app/modules/teacher/history/bindings/teacher_history_binding.dart';
import 'package:clevora/app/modules/teacher/attendance/views/attendance_view.dart';
import 'package:clevora/app/modules/teacher/attendance/bindings/attendance_binding.dart';
import 'package:clevora/app/modules/teacher/attendance/views/attendance_history_view.dart';
import 'package:clevora/app/modules/teacher/attendance/bindings/attendance_history_binding.dart';
import 'package:clevora/app/modules/teacher/history/views/history_view.dart';

// Teacher AI Generate
import 'package:clevora/app/modules/teacher/ai_generate/views/module_ai_view.dart';
import 'package:clevora/app/modules/teacher/ai_generate/bindings/generate_form_binding.dart';
import 'package:clevora/app/modules/teacher/ai_generate/views/generate_form_view.dart';
import 'package:clevora/app/modules/teacher/ai_generate/bindings/generating_state_binding.dart';
import 'package:clevora/app/modules/teacher/ai_generate/views/generating_state_view.dart';
import 'package:clevora/app/modules/teacher/ai_generate/bindings/ai_result_binding.dart';
import 'package:clevora/app/modules/teacher/ai_generate/views/ai_result_view.dart';

// Student
import 'package:clevora/app/modules/student/student_main/bindings/student_main_binding.dart';
import 'package:clevora/app/modules/student/student_main/views/student_main_view.dart';
import 'package:clevora/app/modules/student/dashboard/bindings/student_home_binding.dart';
import 'package:clevora/app/modules/student/dashboard/views/student_home_view.dart';
import 'package:clevora/app/modules/student/learning/bindings/learning_binding.dart';
import 'package:clevora/app/modules/student/learning/views/learning_view.dart';
import 'package:clevora/app/modules/student/student_quiz/bindings/student_quiz_binding.dart';
import 'package:clevora/app/modules/student/student_quiz/views/student_quiz_view.dart';
import 'package:clevora/app/modules/student/exam_instruction/bindings/exam_instruction_binding.dart';
import 'package:clevora/app/modules/student/exam_instruction/views/exam_instruction_view.dart';
import 'package:clevora/app/modules/student/student_exam/bindings/student_exam_binding.dart';
import 'package:clevora/app/modules/student/student_exam/views/student_exam_view.dart';
import 'package:clevora/app/modules/student/student_result/bindings/student_result_binding.dart';
import 'package:clevora/app/modules/student/student_result/views/student_result_view.dart';
import 'package:clevora/app/modules/student/student_qr_scanner/bindings/student_qr_scanner_binding.dart';
import 'package:clevora/app/modules/student/student_qr_scanner/views/student_qr_scanner_view.dart';

// Shared
import 'package:clevora/app/modules/shared/profile/bindings/profile_binding.dart';
import 'package:clevora/app/modules/shared/profile/views/profile_view.dart';
import 'package:clevora/app/modules/shared/edit_profile/views/edit_profile_view.dart';
import 'package:clevora/app/modules/shared/edit_profile/bindings/edit_profile_binding.dart';
import 'package:clevora/app/modules/shared/profile/views/security_log_view.dart';
import 'package:clevora/app/modules/shared/profile/bindings/security_log_binding.dart';
import 'package:clevora/app/modules/shared/video_player/bindings/video_player_binding.dart';
import 'package:clevora/app/modules/shared/video_player/views/video_player_view.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Auth
    GetPage(name: Routes.SPLASH, page: () => const SplashView(), binding: SplashBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.LOGIN, page: () => const LoginView(), binding: LoginBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.REGISTER, page: () => const RegisterView(), binding: RegisterBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.COMPLETE_PROFILE, page: () => const CompleteProfileView(), binding: CompleteProfileBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.OTP, page: () => const OtpView(), binding: OtpBinding(), transition: Transition.rightToLeft),
    
    // Teacher
    GetPage(name: Routes.TEACHER_MAIN, page: () => const TeacherMainView(), binding: TeacherMainBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.TEACHER_HOME, page: () => const TeacherHomeView(), binding: TeacherHomeBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.QUIZ_MANAGEMENT, page: () => const QuizManagementView(), transition: Transition.rightToLeft),
    GetPage(name: Routes.MANUAL_QUIZ_QUESTIONS, page: () => const ManualQuizQuestionsView(), transition: Transition.rightToLeft),
    GetPage(name: Routes.REPORT, page: () => const ReportView(), binding: ReportBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.ATTENDANCE, page: () => const AttendanceView(), binding: AttendanceBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.ATTENDANCE_HISTORY, page: () => AttendanceHistoryView(), binding: AttendanceHistoryBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.TEACHER_HISTORY, page: () => const TeacherHistoryView(), binding: TeacherHistoryBinding(), transition: Transition.rightToLeft),
    
    // Teacher AI Generate
    GetPage(name: Routes.MODULE_AI, page: () => const ModuleAiView(), transition: Transition.rightToLeft),
    GetPage(name: Routes.GENERATE_FORM, page: () => const GenerateFormView(), binding: GenerateFormBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.GENERATING_STATE, page: () => const GeneratingStateView(), binding: GeneratingStateBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.AI_RESULT, page: () => const AiResultView(), binding: AiResultBinding(), transition: Transition.fadeIn),
    
    // Student
    GetPage(name: Routes.STUDENT_MAIN, page: () => const StudentMainView(), binding: StudentMainBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.STUDENT_HOME, page: () => const StudentHomeView(), binding: StudentHomeBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.LEARNING, page: () => const LearningView(), binding: LearningBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.STUDENT_QUIZ, page: () => const StudentQuizView(), binding: StudentQuizBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.EXAM_INSTRUCTION, page: () => const ExamInstructionView(), binding: ExamInstructionBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.STUDENT_EXAM, page: () => const StudentExamView(), binding: StudentExamBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.STUDENT_RESULT, page: () => const StudentResultView(), binding: StudentResultBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.STUDENT_QR_SCANNER, page: () => const StudentQrScannerView(), binding: StudentQrScannerBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.VIDEO_PLAYER, page: () => const VideoPlayerView(), binding: VideoPlayerBinding(), transition: Transition.rightToLeft),
    
    // Shared
    GetPage(name: Routes.PROFILE, page: () => const ProfileView(), binding: ProfileBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.SECURITY_LOG, page: () => const SecurityLogView(), binding: SecurityLogBinding(), transition: Transition.rightToLeft),
    GetPage(name: Routes.EDIT_PROFILE, page: () => EditProfileView(), binding: EditProfileBinding(), transition: Transition.rightToLeft),
  ];
}
