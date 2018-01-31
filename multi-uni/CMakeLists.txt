cmake_minimum_required(VERSION 3.1)

project(multi-uni CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(multi-uni
        main.cc
        DockerfileParser.cc
        DockerfileParser.h
        )
