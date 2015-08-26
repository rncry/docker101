#!/bin/bash

set -eux

BIN="`readlink -f "$0"`"
BIN_DIR="`dirname "$BIN"`"
PARENT_DIR="`readlink -f "${BIN_DIR}/../"`"

# Maintain this order
declare -a TARGETS=(
'mesos/mesosbase' \
'mesos' \
'mesos/master' \
'mesos/slave' \
'mesos/zookeeper' \
'mesos/marathon' \
'mesos/chronos' \
)

cd "$PARENT_DIR"
for target in "${TARGETS[@]}"
do
   cd "$target"
   docker build -t "$target" .
   cd $OLDPWD
done
