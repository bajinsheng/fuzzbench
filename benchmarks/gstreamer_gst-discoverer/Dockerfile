# Copyright 2017 Google Inc.
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

FROM gcr.io/oss-fuzz-base/base-builder@sha256:6cd402d36992b46a9358a6cdbe2d5fa39953d422e739b9dcd3ac227d8ffb6d21
# Install the build dependencies

# install the minimum

RUN sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list" && \
   apt-get update && \
   apt-get install -y make autoconf automake libtool build-essential \
    autopoint pkg-config bison flex gettext libffi-dev liblzma-dev \
    libvorbis-dev libtheora-dev libogg-dev zlib1g-dev

ADD https://ftp.gnome.org/pub/gnome/sources/glib/2.54/glib-2.54.2.tar.xz $SRC

COPY state_variable.patch $SRC/
# Checkout all development repositories
#RUN for i in orc  gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav; do git clone --depth 1 --recursive https://anongit.freedesktop.org/git/gstreamer/$i $i; done
RUN \
  git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git gstreamer && \
  cd gstreamer && \
  git checkout -f 4fb02fc85b70be631f5331b2547e5dc61ef7a43a && \
  cd $SRC && \
  git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git gst-plugins-base && \
  cd $SRC/gst-plugins-base && \
  git checkout -f 4187242a7cbd21170c43a0ebdbd66678f14131ca && \
  cd $SRC && \
  git clone https://gitlab.freedesktop.org/gstreamer/gst-ci.git gst-ci && \
  cd $SRC/gst-ci && \
  git checkout -f f4b08721f7756d8fa361ea4e691aea08b49458b1
#ADD https://people.freedesktop.org/~bilboed/gst-discoverer_seed_corpus.zip $SRC
ADD gst-discoverer_seed_corpus.zip $SRC
WORKDIR gstreamer
COPY build.sh $SRC/
COPY libfuzzer_ocg_build.sh $SRC/
COPY OCGWhitelist $OUT/allowlist.txt
ENV  ALLOWLIST /out/allowlist.txt
