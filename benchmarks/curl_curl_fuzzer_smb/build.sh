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

# Run the OSS-Fuzz script in the curl-fuzzer project.
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

# Save off the current folder as the build root.
export BUILD_ROOT=$PWD
SCRIPTDIR=${BUILD_ROOT}/scripts

. ${SCRIPTDIR}/fuzz_targets

ZLIBDIR=/src/zlib
OPENSSLDIR=/src/openssl
NGHTTPDIR=/src/nghttp2

echo "CC: $CC"
echo "CXX: $CXX"
echo "LIB_FUZZING_ENGINE: $LIB_FUZZING_ENGINE"
echo "CFLAGS: $CFLAGS"
echo "CXXFLAGS: $CXXFLAGS"
echo "ARCHITECTURE: $ARCHITECTURE"
echo "FUZZ_TARGETS: $FUZZ_TARGETS"

export MAKEFLAGS+="-j$(nproc)"

# Make an install directory
export INSTALLDIR=/src/curl_install

# Install the libcurl
git clone https://github.com/bajinsheng/curl_install $INSTALLDIR

# Build the fuzzers.
${SCRIPTDIR}/compile_fuzzer.sh ${INSTALLDIR} || true

# Manually fix the link error caused by the llvm pass by relink
$CXX -g -I/src/curl_install/include -I/src/curl_install/utfuzzer -DFUZZ_PROTOCOLS_SMB -fsanitize=address -fsanitize-address-use-after-scope -stdlib=libc++ -pthread -Wl,--no-as-needed -Wl,-ldl -Wl,-lm -Wno-unused-command-line-argument -fsanitize=fuzzer-no-link -D_GLIBCXX_USE_CXX11_ABI=0 -Xclang -load -Xclang /opt/FuzzerOCGSanitizer.so -o curl_fuzzer_smb curl_fuzzer_smb-curl_fuzzer.o curl_fuzzer_smb-curl_fuzzer_tlv.o curl_fuzzer_smb-curl_fuzzer_callback.o  /src/curl_install/lib/libcurl.a -L/src/curl_install/lib /src/curl_install/lib/libnghttp2.a -ldl -lssl -lcrypto -lz /usr/lib/libFuzzingEngine.a -lpthread -lm -pthread

make zip

# Copy the fuzzers over.
TARGET=curl_fuzzer_smb
cp -v ${TARGET} ${TARGET}_seed_corpus.zip $OUT/

# Copy dictionary and options file to $OUT.
cp -v ossconfig/*.dict ossconfig/*.options $OUT/
