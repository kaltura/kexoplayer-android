#!/bin/bash -exu

VERSION="$1"

# Make sure BINTRAY_USER and BINTRAY_KEY are exported

MYDIR=$(cd $(dirname $0); pwd)
TEMPLATE_DIR="$MYDIR/template"
WORK_DIR="$MYDIR/work"

mkdir "$WORK_DIR"
cd "$WORK_DIR"

## Step 1: Download media3 ExoPlayer
curl -L https://github.com/androidx/media/archive/$VERSION.tar.gz | tar -xz


## Step 2: Prepare the sources
$MYDIR/prepare.sh "media-$VERSION" dist
	
## Step 3: Build
## Step 4: Push to Maven Central
cd dist
./gradlew --no-daemon build
#./gradlew --no-daemon build publish
#./gradlew build uploadArchives
