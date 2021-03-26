#!/bin/bash
# Copyright 2020 Google LLC
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

# Use this script to run a new aflchurnbench experiment.

bash_script_dir=$(realpath $(dirname $0))
csfuzz_root="$(dirname "$bash_script_dir")"

# Make sure submodules use ssh protocol
sed -i .bak 's!https://github.com/!git@github.com:!g' .gitmodules

git pull --rebase
git submodule update --init
git submodule update --remote --merge

# make install-dependencies
# source .venv/bin/activate

# TODO @Jonathan
echo "TODO: Create $HOME/csfuzz-workdir and csfuzz-experiment-config.yaml."
exit 1

# These paths are specific to the user's machine.
experiment_working_dir=$HOME/csfuzz-workdir 
config_filename="csfuzz-experiment-config.yaml"
cd $experiment_working_dir

# High priority: openssl_server, curl_curl_fuzzer_imap, curl_curl_fuzzer_smb, curl_curl_fuzzer_smtp, gstreamer_gst-discoverer
# Low priority: nghttp2_nghttp2_fuzzer, h2o_h2o-fuzzer-http2, mbedtls_fuzz_dtlsserver, curl_curl_fuzzer
# nice to have: ntp_fuzz_ntpd_receive
benchmarks="openssl_server curl_curl_fuzzer_imap curl_curl_fuzzer_smb curl_curl_fuzzer_smtp gstreamer_gst-discoverer nghttp2_nghttp2_fuzzer h2o_h2o-fuzzer-http2 mbedtls_fuzz_dtlsserver curl_curl_fuzzer ntp_fuzz_ntpd_receive"

fuzzers="libfuzzer csfuzz"

experiment_name=$(date --iso-8601)-"csfuzz"

run_experiment=$csfuzz_root/experiment/run_experiment.py
export PYTHONPATH=$csfuzz_root
python $run_experiment --benchmarks $benchmarks --fuzzers $fuzzers --experiment-name $experiment_name --experiment-config $config_filename --allow-uncommitted-changes
