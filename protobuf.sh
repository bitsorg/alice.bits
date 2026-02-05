package: protobuf
version: v29.3
tag: v29.3
source: https://github.com/protocolbuffers/protobuf
build_requires:
  - CMake
  - "GCC-Toolchain:(?!osx)"
  - alibuild-recipe-tools
  - abseil
  - ninja
prepend_path:
  # The protobuf headers must match the protoc binary version, so prevent the
  # use of system headers by putting ours first in the path.
  PKG_CONFIG_PATH: "$PROTOBUF_ROOT/lib/pkgconfig"
  CMAKE_PREFIX_PATH: "$PROTOBUF_ROOT/lib/cmake"
---
#!/bin/bash -e
if [ -f $SOURCEDIR/cmake/CMakeLists.txt ]; then
  CMAKE_SOURCE_DIR=$SOURCEDIR/cmake
else
  CMAKE_SOURCE_DIR=$SOURCEDIR
fi
cmake -S "$CMAKE_SOURCE_DIR"              \
    -DCMAKE_INSTALL_PREFIX="$INSTALLROOT" \
    -Dprotobuf_BUILD_TESTS=NO             \
    -Dprotobuf_MODULE_COMPATIBLE=YES      \
    -Dprotobuf_BUILD_SHARED_LIBS=OFF      \
    -Dprotobuf_ABSL_PROVIDER=package      \
    -DCMAKE_INSTALL_LIBDIR=lib            \
    -DCMAKE_PREFIX_PATH="$ABSEIL_ROOT"


cmake --build . -- ${JOBS:+-j$JOBS} install
sed -i.bak 's|absl/log/absl_log.h|absl/log/vlog_is_on.h|' $INSTALLROOT/include/google/protobuf/io/coded_stream.h
rm $INSTALLROOT/include/google/protobuf/io/coded_stream.h.bak

mkdir -p "$INSTALLROOT/etc/modulefiles"
alibuild-generate-module --bin --lib > "$INSTALLROOT/etc/modulefiles/$PKGNAME"
