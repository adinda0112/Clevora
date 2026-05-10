
import "dart:io";

void main() async {
  final libDir = Directory("c:/clevora/lib");
  final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith(".dart"));

  for (final file in files) {
    var content = file.readAsStringSync();
    if (content.contains("package:clevora/app/modules/routes/app_routes.dart")) {
      content = content.replaceAll(
        "package:clevora/app/modules/routes/app_routes.dart", 
        "package:clevora/app/routes/app_routes.dart"
      );
      file.writeAsStringSync(content);
    }
    if (content.contains("package:clevora/app/modules/theme/app_theme.dart")) {
        content = content.replaceAll(
        "package:clevora/app/modules/theme/app_theme.dart", 
        "package:clevora/app/theme/app_theme.dart"
      );
      file.writeAsStringSync(content);
    }
  }
  print("Routes fixed.");
}

