#!/bin/bash

set -ex
mkdir -p _build${PYVER}
cd _build${PYVER}

if [ "${PY3K}" -eq 1 ]; then
else
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON3=no -DENABLE_SWIG_PYTHON2=yes -DPYTHON2_EXECUTABLE=${PYTHON}"
fi

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_SWIG_PYTHON2=no \
	-DENABLE_SWIG_PYTHON3=yes \
	-DPYTHON3_EXECUTABLE="${PYTHON}" \
;

# build
cmake --build python --parallel ${CPU_COUNT} --verbose

# check
ctest --test-dir python --parallel ${CPU_COUNT} --verbose

# install
cmake --build python --parallel ${CPU_COUNT} --verbose --target install
