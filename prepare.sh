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

# Common
cp -R "$INPUT_DIR/library/common/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

# Core
cp -R "$INPUT_DIR/library/extractor/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/extractor"

# DASH and HLS sources
for LIB in dash hls; do
  cp -R "$INPUT_DIR/library/$LIB/src/main/java/com/google/android/exoplayer2/source/$LIB" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/source/$LIB"
done

# UI Java files
cp -R "$INPUT_DIR/library/ui/src/main/java/com/google/android/exoplayer2/ui" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2"

# DATASOURCE Java files
cp -R "$INPUT_DIR/library/datasource/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

# DECODER Java files
cp -R "$INPUT_DIR/library/decoder/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

# DATABASE Java files
cp -R "$INPUT_DIR/library/database/src/main/java/com/google/android/exoplayer2" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/android"

sed '/core.R;$/d' $OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ui/DownloadNotificationHelper.java > /tmp/DownloadNotificationHelper.java
mv /tmp/DownloadNotificationHelper.java $OUTPUT_DIR/lib/src/main/java/com/kaltura/android/exoplayer2/ui/DownloadNotificationHelper.java

# UI res files
cp -R "$INPUT_DIR/library/ui/src/main/res" "$OUTPUT_DIR/lib/src/main"

cp $INPUT_DIR/library/core/src/main/res/values/strings.xml /tmp/kexo_core_strings.xml

perl -i -pe's/\<string/\<string translatable\=\"false\"/g' /tmp/kexo_core_strings.xml
 
cat $INPUT_DIR/library/ui/src/main/res/values/strings.xml  | grep -v "/resources" > /tmp/kexo_strings.xml

cat /tmp/kexo_core_strings.xml | grep "name=" >> /tmp/kexo_strings.xml
echo "</resources>" >> /tmp/kexo_strings.xml
rm /tmp/kexo_core_strings.xml
mv /tmp/kexo_strings.xml $OUTPUT_DIR/lib/src/main/res/values/strings.xml

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
find . -type f -name "*.xml"  -exec perl -i -p -e 's/\@layout\/exo_/\@layout\/kexo_/' {} \;
find . -type f -name "ids.xml"  -exec perl -i -p -e 's/name\=\"exo\_/name\=\"kexo\_/' {} \;
find . -type f -name "*.java"  -exec perl -i -p -e 's/R\.id\.exo_/R\.id\.kexo_/' {} \;

# Rename layout exo->kexo
find . -type f -name "*.java"  -exec perl -i -p -e 's/R\.layout\.exo_/R\.layout\.kexo_/' {} \;

#Rename LayoutFiles exo -> kexo
LAYOUT_XMLS=`find . -name "exo*.xml" | grep layout`
for XML_LAYOUT_FILE in $LAYOUT_XMLS
do
    NEW_XML_LAYOUT_FILE=`echo $XML_LAYOUT_FILE | sed -e "s/exo_/kexo_/"`
    mv $XML_LAYOUT_FILE $NEW_XML_LAYOUT_FILE
done


# Constants file
cp "$INPUT_DIR/constants.gradle" "$OUTPUT_DIR/lib"
