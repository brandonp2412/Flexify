#!/bin/bash

set -ex

./flutter/bin/dart run build_runner build -d
./flutter/bin/dart run drift_dev make-migrations
