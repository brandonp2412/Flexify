cmake_minimum_required(VERSION 3.28)
project(flexifyNative)

set(CMAKE_CXX_STANDARD 17)

add_library(flexifyNative INTERFACE
        flexify_native/timer_service.h
        flexify_native/platform.h
        flexify_native/timer.h
        flexify_native/timestamp.h
)
target_include_directories(flexifyNative INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_compile_features(flexifyNative INTERFACE cxx_std_17)