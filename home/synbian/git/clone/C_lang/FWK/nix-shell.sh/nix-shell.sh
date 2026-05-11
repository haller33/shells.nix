#!/bin/env bash

set +x

nix-shell -p clang llvm cmake lua xorg.libX11 xorg.libXcursor xorg.libXinerama libGL xorg.libXi SDL2 SDL vulkan-loader glfw 
