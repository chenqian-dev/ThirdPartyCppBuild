#!/bin/bash

./build_android.sh armeabi-v7a 16 /Users/chenqian/Library/Android/sdk/ndk/22.0.7026061 "libx264"
./build_android.sh arm64-v8a 21 /Users/chenqian/Library/Android/sdk/ndk/22.0.7026061 "libx264"
./build_android.sh x86 16 /Users/chenqian/Library/Android/sdk/ndk/22.0.7026061 "libx264"
./build_android.sh x86_64 21 /Users/chenqian/Library/Android/sdk/ndk/22.0.7026061 "libx264"