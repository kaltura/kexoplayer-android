#!/bin/bash

INPUT_DIR="$1"
OUTPUT_DIR="$2"

TEMPLATE_DIR="$(dirname $0)/template"

rm -rf "$OUTPUT_DIR"

cp -R "$TEMPLATE_DIR" "$OUTPUT_DIR"

EXO_JAVA_PATH="com/kaltura/android/exoplayer2"

mkdir -p "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"
cp -R "$INPUT_DIR/library/core/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

for LIB in dash hls; do
  cp -R "$INPUT_DIR/library/$LIB/src/main/java/com/google/android/exoplayer2/source/$LIB" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/source/$LIB"
done

cp -R "$INPUT_DIR/library/ui/src/main/java/com/google/android/exoplayer2/ui" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2"

cp -R "$INPUT_DIR/library/ui/src/main/res" "$OUTPUT_DIR/lib/src/main"

find "$OUTPUT_DIR/lib/src/main" -type f \( -name "*.gradle" -o  -name "*.md" -o -name "*.xml" -o -name "*.txt" -o -name "*.json" -o -name "*.java" \) -exec sed -i '' 's/com.google.android.exoplayer2/com.kaltura.android.exoplayer2/' {} \;

find "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ui" -type f -name "*.java" -exec perl -i -p -e 's/package com\.kaltura\.android\.exoplayer2\.ui;/package com.kaltura.android.exoplayer2.ui;\n\nimport com.kaltura.android.exoplayer2.R;/' {} \;

cp "$INPUT_DIR/constants.gradle" "$OUTPUT_DIR/lib"
