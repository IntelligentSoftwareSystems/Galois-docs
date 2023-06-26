find_package(Doxygen REQUIRED)
# TODO: double check the list of directories here
set(DOXYFILE_SOURCE_DIR_LIST
  ${CMAKE_SOURCE_DIR}/docs/doxygen
  ${CMAKE_SOURCE_DIR}/libcusp
  ${CMAKE_SOURCE_DIR}/libdist
  ${CMAKE_SOURCE_DIR}/libgalois/include
  ${CMAKE_SOURCE_DIR}/libgalois/src
  ${CMAKE_SOURCE_DIR}/libgluon
)
# DOXYFILE_SOURCE_DIR
list(JOIN DOXYFILE_SOURCE_DIR_LIST "\" \"" DOXYFILE_SOURCE_DIR)
string(CONCAT DOXYFILE_SOURCE_DIR "\"" ${DOXYFILE_SOURCE_DIR} "\"")
# DOXYFILE_OUTPUT_DIR
set(DOXYFILE_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/doxygen)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.in @ONLY)
add_custom_target(doxygen_docs
    ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.in
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${DOXYFILE_SOURCE_DIR_LIST} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.in
    COMMENT "Generate documentation with Doxygen using ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.in"
  )
add_dependencies(docs doxygen_docs)

