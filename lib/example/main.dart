import 'package:dart_ffi_template/http.dart';
import 'build.dart';

Future<void> main() async {

  await build();

  print('Sending GET request...');
  final response = await httpGet('http://example.com');
  print('Received a response: $response');

  print('Starting HTTP server...');
  httpServe((String request) {
    print('Received a request: $request');
  });

  await Future.delayed(Duration(seconds: 10));
  print('All done');
}
