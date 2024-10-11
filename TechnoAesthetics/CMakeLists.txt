cmake_minimum_required(VERSION 3.27.7)

option(LINK_INSIGHT "Link Qt Insight Tracker library" ON)
option(BUILD_QDS_COMPONENTS "Build design studio components" ON)

project(TechnoAestheticsApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

# set(OpenCV_DIR /opt/homebrew/Cellar/opencv/<version>/lib/cmake/opencv4)
# 设置 OpenCV 库路径
# set(OpenCV_DIR "/usr/local/opt/opencv/lib/cmake/opencv4")

# #查找OpenCV库
# find_package(OpenCV REQUIRED)

# 包含 OpenCV 头文件
# include_directories(${OpenCV_INCLUDE_DIRS})


find_package(Qt6 6.7.1 REQUIRED COMPONENTS Core Gui Qml Quick Widgets Multimedia WebSockets Graphs ShaderTools)

if (Qt6_VERSION VERSION_GREATER_EQUAL 6.7.1)
    qt_standard_project_setup()
endif()

qt_add_executable(TechnoAestheticsApp src/main.cpp


    # src/ImageProcessor.h
    # src/ImageProcessor.cpp
    src/FileManager.h
    src/FileManager.cpp
    src/ThreadPool.hpp
    src/TaskBase.hpp


    src/NetworkManager.h
    src/NetworkManager.cpp
    src/SignalListener.hpp
    src/ChatClient.hpp
    src/SpeechSynthesis.hpp





    )

qt_add_resources(TechnoAestheticsApp "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

target_link_libraries(TechnoAestheticsApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Widgets
    Qt6::Multimedia
    Qt6::WebSockets
    Qt6::Graphs
    Qt6::ShaderTools
)

#链接OpenCV库
# target_link_libraries(TechnoAestheticsApp PRIVATE ${OpenCV_LIBS})

if (BUILD_QDS_COMPONENTS)
    include(${CMAKE_CURRENT_SOURCE_DIR}/qmlcomponents)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/qmlmodules)

if (LINK_INSIGHT)
    include(${CMAKE_CURRENT_SOURCE_DIR}/insight)
endif ()

include(GNUInstallDirs)
install(TARGETS TechnoAestheticsApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
    "Path to the custom QML components defined by the project")
include_directories(${PROJECT_SOURCE_DIR}/imports/json-develop/include/)

