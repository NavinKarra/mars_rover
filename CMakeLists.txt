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

add_executable(c___skeleton src/main.cpp)

add_executable(c___skeleton_test
        test/dummy_test.cpp
        test/initialise_test.cpp)

target_link_libraries(c___skeleton_test
        PRIVATE
        GTest::gtest_main
)
