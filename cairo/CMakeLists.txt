cmake_minimum_required(VERSION 3.10.0)
project(imgui_image VERSION 0.1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} 
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/../lib"
)


# this supposedly puts all the DLLs in the root build/ folder, so that the exe can find them.
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}")
set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}")

find_package(cairo REQUIRED)
include_directories("${Cairo_INCLUDE_DIR}")

add_subdirectory("cimgui")
include_directories("cimgui")

add_library(imgui_image 
    src/cairo_backend.cpp 
    imgui_software_renderer/src/imgui_sw.cpp
)
target_link_libraries(imgui_image ${Cairo_LIBRARIES} cimgui)

add_executable (example src/example.cpp)
target_link_libraries(example ${Cairo_LIBRARIES} cimgui imgui_image)
