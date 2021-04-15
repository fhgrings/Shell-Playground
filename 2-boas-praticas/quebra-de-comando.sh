#!/usr/bin/env bash

find / -name "*.so" \
       -user felipe \
       -type fi     \
       -size +1M    \
       -exec ls {}  \
