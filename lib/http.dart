// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dylib.dart';
import 'bindings.dart';

// Runs a simple HTTP GET request using a native HTTP library that runs
// the request on a background thread.
Future<String> httpGet(String uri) async {
  // Create the NativeCallable.listener.
  final completer = Completer<String>();
  void onResponse(Pointer<Char> responsePointer) {
    print('Dart: onResponse');
    completer.complete(responsePointer.cast<Utf8>().toDartString());
    print('Dart: onResponse done, free');

    bindings.native_free(responsePointer.cast());

    print('Dart: free done, bye');
  }

  final callback = NativeCallable<HttpGetResponseFunction>.listener(onResponse);

  // Invoke the native HTTP API. Our example HTTP library runs our GET
  // request on a background thread, and calls the callback on that same
  // thread when it receives the response.
  final uriPointer = uri.toNativeUtf8();
  bindings.http_get(uriPointer.cast(), callback.nativeFunction);
  calloc.free(uriPointer);

  // Wait for the response.
  final response = await completer.future;

  // Remember to close the NativeCallable once the native API is finished
  // with it, otherwise this isolate will stay alive indefinitely.
  callback.close();

  return response;
}

// Start a HTTP server on a background thread.
void httpServe(void Function(String) onRequest) {
  // Create the NativeCallable.listener.
  void onNativeRequest(Pointer<Char> requestPointer) {
    onRequest(requestPointer.cast<Utf8>().toDartString());
    bindings.native_free(requestPointer.cast());
  }

  final callback = NativeCallable<HttpServeResponseFunction>.listener(onNativeRequest);

  // Invoke the native function to start the HTTP server. Our example
  // HTTP library will start a server on a background thread, and pass
  // any requests it receives to out callback.
  bindings.http_serve(callback.nativeFunction);

  // The server will run indefinitely, and the callback needs to stay
  // alive for that whole time, so we can't close the callback here.
  // But we also don't want the callback to keep the isolate alive
  // forever, so we set keepIsolateAlive to false.
  callback.keepIsolateAlive = false;
}
