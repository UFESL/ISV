FROM ubuntu:18.04

ARG NUM_MAKE_CORES=4
ARG WORK_DIR=/root
ARG SOURCE_DIR=/root/isv
ARG SANDBOX_DIR=/tmp

RUN apt -y update
RUN apt -y install build-essential curl libcap-dev git cmake libncurses5-dev python-minimal python-pip unzip libtcmalloc-minimal4 libgoogle-perftools-dev libsqlite3-dev doxygen python3 python3-pip gcc-multilib g++-multilib wget vim
RUN pip3 install tabulate wllvm
RUN apt -y install clang-6.0 llvm-6.0 llvm-6.0-dev llvm-6.0-tools
RUN ln -s /usr/bin/clang-6.0 /usr/bin/clang
RUN ln -s /usr/bin/clang++-6.0 /usr/bin/clang++
RUN ln -s /usr/bin/llvm-config-6.0 /usr/bin/llvm-config
RUN ln -s /usr/bin/llvm-link-6.0 /usr/bin/llvm-link

WORKDIR ${WORK_DIR}
RUN git clone https://github.com/steveicarus/iverilog.git
WORKDIR ${WORK_DIR}/iverilog
RUN git checkout v10_0
RUN apt install -y cmake bison flex libboost-all-dev python perl minisat gperf autoconf
RUN sh autoconf.sh
RUN ./configure --prefix=${WORK_DIR}/iverilog
RUN make
RUN make install

WORKDIR ${WORK_DIR}
ADD ./lib/yices-2.6.1 ${WORK_DIR}/yices
WORKDIR ${WORK_DIR}/yices
RUN ./install-yices ${WORK_DIR}/yices

RUN echo "export SOURCE_DIR=${SOURCE_DIR}" >> /root/.bashrc
RUN echo "export SANDBOX_DIR=/tmp" >> /root/.bashrc
RUN echo "export LLVM_COMPILER=clang" >> /root/.bashrc
RUN echo "export PYTHONPATH=${PYTHONPATH}:${SOURCE_DIR}" >> /root/.bashrc
RUN echo "export PATH=$PATH:/root/iverilog/bin:/root/iverilog/vvp:/root/yices/bin:/root/isv/Framework" >> /root/.bashrc
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/yices/lib" >> /root/.bashrc

ADD ./lib/tbGenerate.conf ${WORK_DIR}/iverilog/lib/ivl/tbGenerate.conf
ADD ./lib/tbGenerate-s.conf ${WORK_DIR}/iverilog/lib/ivl/tbGenerate-s.conf
ADD ./lib/tbGenerate.tgt ${WORK_DIR}/iverilog/lib/ivl/tbGenerate.tgt
ADD ./lib/conquestMulti.conf ${WORK_DIR}/iverilog/lib/ivl/conquestMulti.conf
ADD ./lib/conquestMulti-s.conf ${WORK_DIR}/iverilog/lib/ivl/conquestMulti-s.conf
ADD ./lib/conquestMulti.tgt ${WORK_DIR}/iverilog/lib/ivl/conquestMulti.tgt

ADD ./Framework ${SOURCE_DIR}/Framework

ADD ./Benchmarks ${SOURCE_DIR}/Benchmarks
WORKDIR ${SOURCE_DIR}
