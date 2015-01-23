project(subproject)

FILE(GLOB SRCS "*")
ADD_EXECUTABLE(${PROJECT_NAME} ${SRC})

# LIST(APPEND LIBS wpcap packet common)
# LIST(APPEND LIBS debug wingetoptd optimized wingetopt)
# TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${LIBS})

# output pdb
output_pdb(${PROJECT_NAME})
