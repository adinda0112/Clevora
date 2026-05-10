
import "dart:io";

void main() async {
  final baseDir = Directory("c:/clevora/lib/app/modules");
  
  // Create folders
  Directory("${baseDir.path}/auth").createSync();
  Directory("${baseDir.path}/teacher").createSync();
  Directory("${baseDir.path}/student").createSync();
  Directory("${baseDir.path}/shared").createSync();
  Directory("${baseDir.path}/teacher/ai_generate").createSync();
  Directory("${baseDir.path}/teacher/ai_generate/views").createSync();
  Directory("${baseDir.path}/teacher/ai_generate/controllers").createSync();
  Directory("${baseDir.path}/teacher/ai_generate/bindings").createSync();

  void moveDir(String from, String to) {
    final dir = Directory("${baseDir.path}/$from");
    if (dir.existsSync()) {
      dir.renameSync("${baseDir.path}/$to");
    }
  }

  void mergeToAi(String from) {
    final dir = Directory("${baseDir.path}/$from");
    if (!dir.existsSync()) return;
    
    for (final folder in ["views", "controllers", "bindings"]) {
      final subDir = Directory("${dir.path}/$folder");
      if (subDir.existsSync()) {
        for (final file in subDir.listSync()) {
          if (file is File) {
            final fileName = file.uri.pathSegments.last;
            file.renameSync("${baseDir.path}/teacher/ai_generate/$folder/$fileName");
          }
        }
      }
    }
    dir.deleteSync(recursive: true);
  }

  // Auth
  for (final f in ["splash", "login", "register", "otp"]) moveDir(f, "auth/$f");
  
  // Teacher
  moveDir("teacher_main", "teacher/teacher_main");
  moveDir("teacher_home", "teacher/dashboard");
  moveDir("quiz_management", "teacher/quiz_management");
  moveDir("report", "teacher/report");

  // Merge AI
  mergeToAi("module_ai");
  mergeToAi("generate_form");
  mergeToAi("generating_state");
  mergeToAi("ai_result");

  // Student
  moveDir("student_main", "student/student_main");
  moveDir("student_home", "student/dashboard");
  moveDir("learning", "student/learning");
  moveDir("student_quiz", "student/student_quiz");
  moveDir("student_exam", "student/student_exam");
  moveDir("exam_instruction", "student/exam_instruction");
  moveDir("student_result", "student/student_result");

  // Shared
  moveDir("profile", "shared/profile");

  // Delete unused
  for (final f in ["home", "dashboard", "module", "quiz", "exam", "result", "generate"]) {
    final d = Directory("${baseDir.path}/$f");
    if (d.existsSync()) d.deleteSync(recursive: true);
  }

  print("Folders reorganized.");
}

