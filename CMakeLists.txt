cmake_minimum_required(VERSION 3.10.0)
project(alloinspector VERSION 0.1.0)

set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(IMPL_OPENGL2 ON CACHE BOOL "" FORCE)
set(IMPL_OPENGL3 ON CACHE BOOL "" FORCE)
set(IMPL_GLFW ON CACHE BOOL "" FORCE)
set(IMPL_EXTRAS ON CACHE BOOL "" FORCE)

# this supposedly puts all the DLLs in the root build/ folder, so that the exe can find them.
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}")
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}")

add_subdirectory(lib/allonet)
add_subdirectory(lib/luajit)
add_subdirectory(lib/luajit-glfw)
add_subdirectory(lib/luajit-imgui)

include_directories(lib/luajit/src)

add_executable (alloinspector src/main.c)
target_link_libraries (alloinspector allonet libluajit glfw cimgui_glfw)
