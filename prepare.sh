#!/bin/bash -exu

INPUT_DIR="$1"
OUTPUT_DIR="$2"

TEMPLATE_DIR="$(dirname $0)/template"

rm -rf "$OUTPUT_DIR"

cp -R "$TEMPLATE_DIR" "$OUTPUT_DIR"

EXO_JAVA_PATH="com/kaltura/android/exoplayer2"

mkdir -p "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

# Core
cp -R "$INPUT_DIR/library/core/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

# DASH and HLS sources
for LIB in dash hls; do
  cp -R "$INPUT_DIR/library/$LIB/src/main/java/com/google/android/exoplayer2/source/$LIB" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/source/$LIB"
done

# UI Java files
cp -R "$INPUT_DIR/library/ui/src/main/java/com/google/android/exoplayer2/ui" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2"

# UI res files
cp -R "$INPUT_DIR/library/ui/src/main/res" "$OUTPUT_DIR/lib/src/main"

# OkHttp extension
mkdir "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ext"
cp -R "$INPUT_DIR/extensions/okhttp/src/main/java/com/google/android/exoplayer2/ext/okhttp" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ext"

# Find com.google.android.exoplayer2 in source code and replace to com.kaltura.android.exoplayer2
find "$OUTPUT_DIR/lib/src/main" -type f \( -name "*.gradle" -o  -name "*.md" -o -name "*.xml" -o -name "*.txt" -o -name "*.json" -o -name "*.java" \) -exec sed -i '' 's/com.google.android.exoplayer2/com.kaltura.android.exoplayer2/' {} \;

# Add R import to UI source files
find "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ui" -type f -name "*.java" -exec perl -i -p -e 's/package com\.kaltura\.android\.exoplayer2\.ui;/package com.kaltura.android.exoplayer2.ui;\n\nimport com.kaltura.android.exoplayer2.R;/' {} \;

# Rename ids exo->kexo
find . -type f -name "*.xml"  -exec perl -i -p -e 's/\@id\/exo_/\@id\/kexo_/' {} \;
find . -type f -name "*.xml"  -exec perl -i -p -e 's/\@\+id\/exo_/\@\+id\/kexo_/' {} \;
find . -type f -name "ids.xml"  -exec perl -i -p -e 's/name\=\"exo\_/name\=\"kexo\_/' {} \;
find . -type f -name "*.java"  -exec perl -i -p -e 's/R\.id\.exo_/R\.id\.kexo_/' {} \;

# Constants file
cp "$INPUT_DIR/constants.gradle" "$OUTPUT_DIR/lib"
