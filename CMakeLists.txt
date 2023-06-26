cmake_minimum_required(VERSION 3.20)

project(Galois)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

# BUILD_DOCS could be passed from Galois root
set(DOC_TYPES "external" "internal")
if(NOT BUILD_DOCS)
  set(BUILD_DOCS "external" CACHE STRING "Documentation build type: external (default), internal. `external` docs hide '*-draft*' and '*-internal* documentation pages and directories when building documentation.")
  set_property(CACHE BUILD_DOCS PROPERTY STRINGS DOC_TYPES)
endif()
if(NOT (BUILD_DOCS IN_LIST DOC_TYPES))
  message(STATUS "Unknown documentation build type: '${BUILD_DOCS}'; default to 'external'")
  set(BUILD_DOCS "external")
endif()

# GALOIS_ROOT could be passed from Galois root
if(NOT GALOIS_ROOT)
  if(DEFINED ENV{GALOIS_ROOT})
    set(GALOIS_ROOT $ENV{GALOIS_ROOT})
  else()
    set(GALOIS_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/.. CACHE PATH "Path to the root of the Galois source repo")
  endif()
  message(STATUS "Galois rooted at ${GALOIS_ROOT}")
endif()

# Use both "doc" and "docs" to make people with different mental conventions happy
add_custom_target(docs)
add_custom_target(doc)
add_dependencies(doc docs)

find_package(Doxygen REQUIRED)
# TODO: double check the list of directories here
set(DOXYFILE_SOURCE_DIR_LIST
  ${PROJECT_SOURCE_DIR}/doxygen
  ${GALOIS_ROOT}/libgalois/include
  ${GALOIS_ROOT}/libgalois/src
  ${GALOIS_ROOT}/libdist
  ${GALOIS_ROOT}/libcusp
  ${GALOIS_ROOT}/libgluon
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

find_package(Sphinx)
if(SPHINX_FOUND)
  set(SPHINX_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR "sphinx" OUTPUT_VARIABLE SPHINX_DEFAULT_BUILD_DIR)
  set(SPHINX_BUILD_DIR ${SPHINX_DEFAULT_BUILD_DIR} CACHE PATH "Sphinx doc build path")
  cmake_path(APPEND DOXYFILE_OUTPUT_DIR "xml" OUTPUT_VARIABLE DOXYFILE_XML_OUTPUT_DIR)

  cmake_path(APPEND SPHINX_SOURCE_DIR "api" OUTPUT_VARIABLE BREATHE_APIDOC_DIR)
  add_custom_target(breathe_apidoc  # ALL
                  COMMAND breathe-apidoc -q -o ${BREATHE_APIDOC_DIR} ${DOXYFILE_XML_OUTPUT_DIR}
                  COMMAND rm -rf ${BREATHE_APIDOC_DIR}/namespace*  # Ad hoc to faulty namespace recognition
                  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                  DEPENDS ${DOXYFILE_XML_OUTPUT_DIR}
                  COMMENT "Generating documentation with Sphinx"
                  )
  set_property(TARGET breathe_apidoc APPEND PROPERTY ADDITIONAL_CLEAN_FILES ${BREATHE_APIDOC_DIR})
  add_dependencies(breathe_apidoc doxygen_docs)
  add_custom_target(sphinx_docs  # ALL
                  COMMAND ${SPHINX_EXECUTABLE} -b html -D breathe_projects.Galois=${DOXYFILE_XML_OUTPUT_DIR} ${SPHINX_SOURCE_DIR} ${SPHINX_BUILD_DIR}
                  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/conf.py ${SPHINX_SOURCE_DIR} ${DOXYFILE_XML_OUTPUT_DIR}
                  COMMENT "Generating documentation with Sphinx"
                )
  add_dependencies(sphinx_docs breathe_apidoc)
  add_dependencies(docs sphinx_docs)
endif()
