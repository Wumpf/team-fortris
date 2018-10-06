cmake_minimum_required(VERSION 3.5)
enable_language(Fortran)
project(team-fortris)

if(NOT CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    message(FATAL_ERROR "No supported compiler found!")
endif()

# Can't do F77 with gfortan, but we can get a bit closer with these dialect options.
# F77 allows only 6 chars for variables. We can't do that here since gfortran applies this rules to keywords as well. So we go with F95's 31
set(dialect "-ffixed-form -std=legacy -ffixed-line-length-72 -fmax-identifier-length=31")
set(warnings "-Wpedantic -Wall")
set(checks "-fbounds-check")
set(stripping "-Wl,--exclude-libs,ALL -fvisibility=hidden -s")

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${dialect} ${warnings} ${checks}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${stripping}")


file(GLOB sources *.f)
add_executable(${PROJECT_NAME} ${sources})

# sdl as static library
#target_link_libraries(prog "${PROJECT_SOURCE_DIR}/SDL2-2.0.8/x86_64-w64-mingw32/lib/libSDL2.a")
#target_link_libraries(prog advapi32 gdi32 imm32 kernel32 msvcrt ole32 oleaut32 shell32 user32 version winmm)

# sdl as dynamic library
target_link_libraries(${PROJECT_NAME} "${PROJECT_SOURCE_DIR}/SDL2-2.0.8/x86_64-w64-mingw32/lib/libSDL2.dll.a")
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
                   -E copy "${PROJECT_SOURCE_DIR}/SDL2-2.0.8/x86_64-w64-mingw32/bin/SDL2.dll" "${CMAKE_BINARY_DIR}/SDL2.dll")