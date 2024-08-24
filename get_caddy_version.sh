#!/bin/bash

TARGET_FILE="README_english.md"

version_line=$(awk '/^### Based caddy version/{getline; getline; print; exit}' $TARGET_FILE)

version_line_tripped=$(echo $version_line | xargs)

echo ${version_line_tripped:1:${#version_line_tripped}-2}