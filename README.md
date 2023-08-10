# Galois Documentation

This is the standalone documentation repository for [Galois](https://github.com/IntelligentSoftwareSystems/Galois) and its variants.

## Build with CMake

Replace the `docs` directory in the original Galois repository with this repository as a submodule, and run `cmake` from the build directory.
```
<build-dir>$ cmake <path-to-here>
```

If this repository is cloned elsewhere, specify the path to the Galois repository (by default it's the parent directory).
```
<build-dir>$ GALOIS_ROOT=<path-to-galois> cmake <path-to-here>
<build-dir>$ cmake -DGALOIS_ROOT=<path-to-galois> <path-to-here>
```

To enable documentations for internal and anonymous namespaces, specify the build type to be *internal*.
```
cmake -DBUILD_DOCS=internal
```

## Generate with Make
```
make doc  # equivalently, make docs
```

To generate only Doxygen/Sphinx flavor documentation:
```
make doxygen_docs
make sphinx_docs
```