#!/bin/bash

SCHEME='Counter'

cd SampleApp
xcodebuild test -scheme $SCHEME CODE_SIGNING_ALLOWED='NO'
