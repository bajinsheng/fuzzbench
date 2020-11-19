# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM gcr.io/fuzzbench/base-image
RUN apt-get install -y vim valgrind wget libstdc++-5-dev libexpat1-dev && \
    apt-get install -y apt-utils apt-transport-https ca-certificates && \
    echo deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-11 main >> /etc/apt/sources.list && \
    echo deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main >> /etc/apt/sources.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1E9377A2BA9EF27F && \
    apt-get update && \
    apt-get install -y llvm-11
