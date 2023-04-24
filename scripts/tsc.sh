#!/bin/bash

find preBuild -name "index.ts" | xargs tsc
find plugins -name "index.ts" | xargs tsc