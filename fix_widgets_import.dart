
import "dart:io";

void main() async {
  final libDir = Directory("c:/clevora/lib");
  final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith(".dart"));

  for (final file in files) {
    var content = file.readAsStringSync();
    if (content.contains("package:clevora/app/modules/widgets/")) {
      content = content.replaceAll(
        "package:clevora/app/modules/widgets/", 
        "package:clevora/app/widgets/"
      );
      file.writeAsStringSync(content);
    }
  }
  print("Widgets fixed.");
}

