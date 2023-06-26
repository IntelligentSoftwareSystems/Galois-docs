find_program(SPHINX_EXECUTABLE
          NAMES sphinx-build
          DOC "sphinx-build bin path"
        )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Sphinx
          DEFAULT_MSG  # "Failed to find sphinx-build executable"
          SPHINX_EXECUTABLE)
