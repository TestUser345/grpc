#!/bin/bash
# Copyright 2015, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e

cd $(dirname $0)

set -o pipefail
echo 'Complete dir listing:'
echo `ls -lR /Users/travis/Library/Developer/Xcode/DerivedData`
echo 'running code_coverage from: '
echo `pwd`
PROJECT_TEMP_ROOT=`xcodebuild -workspace Tests.xcworkspace/ -scheme AllTests \
                  -destination name="iPhone 6" test -dry-run -showBuildSettings \
                  | grep PROJECT_TEMP_ROOT | sed 's/^.* = //'`
echo PROJECT_TEMP_ROOT=$PROJECT_TEMP_ROOT

SRCROOT=`pwd | sed 's/.tests//'`
echo SRCROOT=$SRCROOT

INSTRUMENTED_EXE_PATH=$PROJECT_TEMP_ROOT/CodeCoverage/AllTests/Products/Debug-iphonesimulator/AllTests.xctest/AllTests
echo INSTRUMENTED_EXE_PATH=$INSTRUMENTED_EXE_PATH
CODE_COVERAGE_DATA=$PROJECT_TEMP_ROOT/CodeCoverage/AllTests/Coverage.profdata
echo CODE_COVERAGE_DATA=$CODE_COVERAGE_DATA
echo `ls -l $CODE_COVERAGE_DATA`
echo `ls -l $INSTRUMENTED_EXE_PATH`
xcrun llvm-cov report -instr-profile $CODE_COVERAGE_DATA $INSTRUMENTED_EXE_PATH $SRCROOT/*/*.m $SRCROOT/*/*/*.m 
