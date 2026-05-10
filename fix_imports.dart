import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final libDir = Directory('c:/clevora/lib');
  final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final importRegex = RegExp(r"import\s+['""](\.\./[^'""]+)['""];");

  for (final file in files) {
    var content = file.readAsStringSync();
    if (!importRegex.hasMatch(content)) continue;

    final fileDir = file.parent.path;

    content = content.replaceAllMapped(importRegex, (match) {
      final relativeImport = match.group(1)!;
      final absolutePath = p.normalize(p.join(fileDir, relativeImport));
      
      final libNormalized = p.normalize(libDir.path);
      if (absolutePath.startsWith(libNormalized)) {
        final packagePath = absolutePath.substring(libNormalized.length + 1).replaceAll(r'\', '/');
        return "import 'package:clevora/$packagePath';";
      }
      return match.group(0)!;
    });

    file.writeAsStringSync(content);
  }
  print('Imports fixed.');
}
