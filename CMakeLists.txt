cmake_minimum_required(VERSION 3.5)
project(c___skeleton)

set(CMAKE_CXX_STANDARD 20)

include(FetchContent)

set(CMAKE_POLICY_VERSION_MINIMUM 3.5)

FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.17.0
)

FetchContent_MakeAvailable(googletest)

add_executable(c___skeleton
        src/main.cpp
        src/rover.h)

add_executable(c___skeleton_test
        test/initialise_test.cpp
        test/move_forward_test.cpp)

target_link_libraries(c___skeleton_test
        PRIVATE
        GTest::gtest_main
)

target_include_directories(c___skeleton_test PRIVATE src)
