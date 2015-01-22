macro(config_cmake)
    # debug库后缀
    set(CMAKE_DEBUG_POSTFIX d)
    # 目标输出目录
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/bin)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/lib)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/bin)
endmacro()

function(cxx_shared_library name)
  add_library(${name} SHARED ${ARGN})
endfunction()

function(cxx_library name)
  if (BUILD_SHARED_LIBS)
      set(type SHARED)
  else()
      set(type STATIC)
  endif()
  add_library(${name} ${type} ${ARGN})
  message(STATUS "${name} ${type} ${ARGN}")
endfunction()

# 使用第三方库，添加include路径，lib路径
function(use_library)
    foreach(name ${ARGN})
        if(${name} STREQUAL ".")
            include_directories(${PROJECT_SOURCE_DIR}/include)
            link_directories(${PROJECT_SOURCE_DIR}/lib)
        else()
            message(${PROJECT_SOURCE_DIR}/3rdparty/${name}/include)
            include_directories(${PROJECT_SOURCE_DIR}/3rdparty/${name}/include)
            link_directories(${PROJECT_SOURCE_DIR}/3rdparty/${name}/lib)
        endif()
    endforeach()
endfunction()

# 单元测试需要链接的库
function(utest_link)
    set(UTEST_LIBRARIES ${ARGN} CACHE INTERNAL "UTEST_LIBRARIES")
endfunction()

# 添加单元测试
# @param [in] name 单元测试名，被测试文件名
function(add_utest name)
    # message("${UTEST_LIBRARIES}")
    set(TESTCASE ${name}_test)
    add_executable(${TESTCASE} ${name}_test.cpp)
    target_link_libraries(${TESTCASE} ${UTEST_LIBRARIES})
    add_test(${PROJECT_NAME} ${TESTCASE})
endfunction()
