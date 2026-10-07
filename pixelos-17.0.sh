#!/bin/bash

echo "==> Cleaning local manifests..."
rm -rf .repo/local_manifests

echo "==> Initializing repo..."
repo init --no-repo-verify --git-lfs -u https://github.com/PixelOS-AOSP/android_manifest.git -b seventeen -g default,-mips,-darwin,-notdefault --depth 1 || true

echo "==> Cloning local manifest..."
git clone https://github.com/xiaomi-amethyst/local_manifest --depth 1 -b pixelos-17.0 .repo/local_manifests

echo "==> Resyncing source tree..."
/opt/crave/resync.sh

echo "==> Applying Soong OOM/Memory patches..."
wget -O build/soong/java/droidstubs.go https://github.com/SourceLab081/uploadz/releases/download/v0.1.8/droidstubs.go
wget -O build/soong/java/config/config.go https://github.com/SourceLab081/uploadz/releases/download/v0.1.8/config.go
wget -O build/soong/java/config/kotlin.go https://github.com/SourceLab081/uploadz/releases/download/v0.1.8/kotlin.go
wget -O build/soong/cmd/soong_build/main.go https://github.com/yaap-17-stone/build_soong/raw/f9c27b0b9298f6eeee9a850346e0a646c3eaeb87/cmd/soong_build/main.go

echo "==> Setting up build environment..."
source build/envsetup.sh
breakfast amethyst userdebug

echo "==> Starting build..."
m pixelos || ./out/siso_failed_commands.sh
