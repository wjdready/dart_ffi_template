import 'dart:convert';
import 'dart:io';

Future<void> printProcessOutput(Process process) async {
  process.stdout.transform(utf8.decoder).listen(stdout.write);
  process.stderr.transform(utf8.decoder).listen((line) {
    print('Error: $line');
  });
  await process.exitCode;
}

Future<void> build() async {
  final srcDir = Directory('${Directory.current.path}/src');
  final buildDir = Directory('${srcDir.path}/build');

  if (!buildDir.existsSync()) {
    buildDir.createSync(recursive: true);
  }

  List<String> arguments = ['-S', srcDir.path, '-B', buildDir.path];

  if (Platform.isWindows) {
    arguments.addAll(['-G', "Visual Studio 17 2022"]);
  }

  final cmakeConfigProcess = await Process.start(
    'cmake',
    arguments,
  );
  await printProcessOutput(cmakeConfigProcess);

  final cmakeBuildProcess = await Process.start(
    'cmake',
    ['--build', buildDir.path],
  );
  await printProcessOutput(cmakeBuildProcess);
}

Future<void> clean() async {
  final srcDir = Directory('${Directory.current.path}/src');
  final buildDir = Directory('${srcDir.path}/build');
  final dllFile = File('${srcDir.path}/dart_ffi_template.dll');

  if (buildDir.existsSync()) {
    await buildDir.delete(recursive: true);
  }

  if (dllFile.existsSync()) {
    await dllFile.delete();
  }
}

void main(List<String> args) async {
  if (args.contains('clean')) {
    await clean();
  } else {
    await build();
  }
}
