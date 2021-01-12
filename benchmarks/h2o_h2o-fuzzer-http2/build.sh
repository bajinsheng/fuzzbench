#!/bin/bash -eu
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################
#pushd $SRC/
#patch -p0 -i state_variable.patch
#popd

pushd $SRC/h2o
if [ "$FUZZER" = "ifcg" ] || [ "$FUZZER" = "origin" ]; then
cmake -DCMAKE_C_FLAGS="-pthread -Wl,--no-as-needed -Wl,-ldl -Wl,-lm -Wno-unused-command-line-argument" -DCMAKE_CXX_FLAGS="-pthread -Wl,--no-as-needed -Wl,-ldl -Wl,-lm -Wno-unused-command-line-argument" -DBUILD_FUZZER=ON -DOSS_FUZZ=ON -DOPENSSL_USE_STATIC_LIBS=TRUE -DCMAKE_BUILD_TYPE=Debug .
fi
cmake  -DCMAKE_C_FLAGS="${CFLAGS}" -DCMAKE_CXX_FLAGS="${CXXFLAGS}" -DBUILD_FUZZER=ON -DOSS_FUZZ=ON -DCMAKE_BUILD_TYPE=Debug -DOPENSSL_USE_STATIC_LIBS=TRUE .
make h2o-fuzzer-http2
cp ./h2o-fuzzer-* $OUT/

#zip -jr $OUT/h2o-fuzzer-http2_seed_corpus.zip $SRC/h2o/fuzz/http2-corpus
#mkdir $OUT/seeds
#cp $SRC/h2o/fuzz/http2-corpus/* $OUT/seeds/
cp -r /opt/seeds $OUT/
cp $SRC/*.options $SRC/h2o/fuzz/*.dict $OUT/
popd
