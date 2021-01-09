#!/bin/bash

git_dir="vapor-playground"
git_url="https://github.com/redmatteo/$git_dir"
server_address=157.245.244.228
server_port=80

echo "1. Check git folder /$git_dir exists"

if [ -d "$git_dir" ]; then
    echo "1.1 Folder /$git_dir exists"

else
    echo "1.1 Folder /$git_dir not found"
    echo "1.2 Clone project from /$git_url"
    git clone $git_url
fi

echo "2. Enter to the folder /$git_dir"
cd $git_dir

echo "3. Build Vapor project"
swift build --enable-test-discovery

echo "4. Run Vapor project"
.build/debug/Run serve -b $server_address:$server_port