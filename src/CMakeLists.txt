cmake_minimum_required(VERSION 3.10)

project(dart_ffi_template)

add_library(dart_ffi_template SHARED
    "export.cpp"
)

if(WIN32)
    target_sources(dart_ffi_template PRIVATE export.def)
endif()

# 在构建完成后将 DLL 文件复制到上一级目录
add_custom_command(TARGET dart_ffi_template POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:dart_ffi_template> ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Copying dart_ffi_template DLL to parent directory"
)
