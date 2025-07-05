
dart ffi template

## How to run

```sh 
# search all dart_ffi_template and replace to your_custom_name

# run example
dart run lib/example/main.dart

# build dll
dart run lib/example/build.dart

# clean 
dart run lib/example/build.dart clean

# clean all ignore file to keep workspace clear
git clean -fdx
```

## Run example in flutter

### Create platform folder (ffi package only)

For example windows,

create windows/CMakeLists.txt

```sh
cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME "dart_ffi_template")
project(${PROJECT_NAME} LANGUAGES CXX)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

set(dart_ffi_template_bundled_libraries
  $<TARGET_FILE:dart_ffi_template>
  PARENT_SCOPE
)
```

and modify the pubspec.yaml

```sh
flutter:
  plugin:
    platforms:
      windows:
        ffiPlugin: true
```

### Add package to example project

Run `flutter create example` and copy all to lib/main.dart
Add package to pubspec.yaml
  dart_package_template:
    path: ../
