#!/bin/bash -exu

INPUT_DIR="$1"
OUTPUT_DIR="$2"

TEMPLATE_DIR="$(dirname $0)/template"

rm -rf "$OUTPUT_DIR"

cp -R "$TEMPLATE_DIR" "$OUTPUT_DIR"

EXO_JAVA_PATH="com/kaltura/androidx/media3"

#mkdir -p "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx"

mkdir -p "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/extractor"
mkdir -p "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/source/"

# Core
cp -R "$INPUT_DIR/libraries/exoplayer/src/main/java/androidx/media3/exoplayer" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# Common
cp -R "$INPUT_DIR/libraries/common/src/main/java/androidx/media3/common" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# Core
cp -R "$INPUT_DIR/libraries/extractor/src/main/java/androidx/media3/extractor" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"
cp -R "$INPUT_DIR/libraries/container/src/main/java/androidx/media3/container" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# DASH and HLS sources
cp -R "$INPUT_DIR/libraries/exoplayer_dash/src/main/java/androidx/media3/exoplayer/dash" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/exoplayer/dash"
cp -R "$INPUT_DIR/libraries/exoplayer_hls/src/main/java/androidx/media3/exoplayer/hls" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/exoplayer/hls"

# UI Java files
cp -R "$INPUT_DIR/libraries/ui/src/main/java/androidx/media3/ui" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# DATASOURCE Java files
cp -R "$INPUT_DIR/libraries/datasource/src/main/java/androidx/media3/datasource" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# DECODER Java files
cp -R "$INPUT_DIR/libraries/decoder/src/main/java/androidx/media3/decoder" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

# DATABASE Java files
cp -R "$INPUT_DIR/libraries/database/src/main/java/androidx/media3/database" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3"

sed -i'' -e  's/androidx\.media3\.exoplayer\.R/androidx\.media3\.R/' $OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/exoplayer/offline/DownloadNotificationHelper.java

# UI res files
cp -R "$INPUT_DIR/libraries/ui/src/main/res/" "$OUTPUT_DIR/lib/src/main/res"

cp $INPUT_DIR/libraries/exoplayer/src/main/res/values/strings.xml /tmp/kexo_core_strings.xml

perl -i -pe's/\<string/\<string translatable\=\"false\"/g' /tmp/kexo_core_strings.xml
 
cat $INPUT_DIR/libraries/ui/src/main/res/values/strings.xml  | grep -v "/resources" > /tmp/kexo_strings.xml

cat /tmp/kexo_core_strings.xml | grep "name=" >> /tmp/kexo_strings.xml
echo "</resources>" >> /tmp/kexo_strings.xml
rm /tmp/kexo_core_strings.xml

mv /tmp/kexo_strings.xml ./$OUTPUT_DIR/lib/src/main/res/values/strings.xml

# OkHttp extension
mkdir "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/ext"
cp -R "$INPUT_DIR/libraries/datasource_okhttp/src/main/java/androidx/media3/datasource/okhttp" "$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/ext"

# Find com.google.android.exoplayer2 in source code and replace to com.kaltura.android.exoplayer2
find "./$OUTPUT_DIR/lib/src/main" -type f \( -name "*.gradle" -o  -name "*.md" -o -name "*.xml" -o -name "*.txt" -o -name "*.json" -o -name "*.java" \) -exec perl -i -p -e 's/androidx.media3/com.kaltura.androidx.media3/' '{}' ';'
# Add R import to UI source files
find "./$OUTPUT_DIR/lib/src/main/java/com/kaltura/androidx/media3/ui" -type f -name "*.java" -exec perl -i -p -e 's/package com\.kaltura\.androidx\.media3\.ui;/package com.kaltura.androidx.media3.ui;\n\nimport com.kaltura.androidx.media3.R;/' {} \;

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
