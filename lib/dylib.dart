import 'dart:ffi';
import 'dart:io';
import 'bindings.dart';

const String _libName = 'dart_ffi_template';

Uri dylibPath(String name, Uri path) {
  if (Platform.isLinux || Platform.isAndroid || Platform.isFuchsia) {
    return path.resolve("lib$name.so");
  }
  if (Platform.isMacOS) return path.resolve("lib$name.dylib");
  if (Platform.isWindows) return path.resolve("$name.dll");
  throw Exception("Platform not implemented");
}

DynamicLibrary dlopenPlatformSpecific(String name, {List<Uri>? paths}) {
  return DynamicLibrary.open((paths ?? [Uri()]).map((path) {
    print("path: $path");
    return dylibPath(name, path).toFilePath();
  }).firstWhere((lib) => File(lib).existsSync()));
}

final DynamicLibrary dylib = dlopenPlatformSpecific(_libName, paths: [
  Uri.directory("src"),
  Uri.directory(""),
  Uri.file(Platform.resolvedExecutable),
]);

final dart_ffi_template bindings = dart_ffi_template(dylib);
