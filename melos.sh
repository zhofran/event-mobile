#!/bin/bash

# Melos wrapper script for FVM projects
# This script ensures melos uses the correct Dart SDK from FVM

# Check if we're in a directory with .fvmrc
if [ ! -f ".fvmrc" ]; then
    echo "Error: .fvmrc not found. Make sure you're in the project root directory."
    exit 1
fi

# Run melos through FVM to use the correct Dart SDK
fvm dart pub global run melos "$@"