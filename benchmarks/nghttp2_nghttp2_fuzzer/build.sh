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

autoreconf -i
if [ "$FUZZER" = "ifcg" ] || [ "$FUZZER" = "origin" ]; then
sed -i "s/-O2/-O0/g" configure
./configure --enable-lib-only
sed -i "s/\$(CCLD) \$(AM_CFLAGS) \$(CFLAGS)/\$(CCLD) \$(AM_CFLAGS)/g" lib/Makefile
else
./configure --enable-lib-only
fi

make all

$CXX $CXXFLAGS -std=c++11 -Ilib/includes \
    fuzz/fuzz_target.cc -o $OUT/nghttp2_fuzzer \
    $LIB_FUZZING_ENGINE lib/.libs/libnghttp2.a

cp $SRC/*.options $OUT
cp -r /opt/seeds $OUT/
#zip -j $OUT/nghttp2_fuzzer_seed_corpus.zip fuzz/corpus/*/*



