#!/bin/bash

set -ex
mkdir -p _build${PYVER}
cd _build${PYVER}

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DENABLE_SWIG_PYTHON2:BOOL=no \
	-DENABLE_SWIG_PYTHON3:BOOL=yes \
	-DPYTHON3_EXECUTABLE:FILE="${PYTHON}" \
;

# build
cmake --build python --parallel ${CPU_COUNT} --verbose

# check
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
	ctest --test-dir python --parallel ${CPU_COUNT} --verbose
fi

# install
cmake --build python --parallel ${CPU_COUNT} --verbose --target install
