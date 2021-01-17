#!/bin/bash

server_address=10.128.0.35
server_port=80

git pull

echo "- build Vapor project"
swift build --enable-test-discovery

echo "- run Vapor project"
.build/debug/Run serve -b $server_address:$server_port
