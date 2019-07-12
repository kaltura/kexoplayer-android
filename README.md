
ExoPlayer in com.kaltura namespace

# Build Steps

## Step 1: Download ExoPlayer

	$ curl https://github.com/google/ExoPlayer/archive/r$VERSION.tar.gz > exoplayer.tgz
	$ tar -xzf exoplayer.tgz
	
This will create a directory ExoPlayer-rVERSION.

## Step 2: Prepare the sources

	$ ./prepare.sh EXOPLAYER_INPUT_DIR OUTPUT_DIR
	
## Step 3: Build

	$ ./gradlew publishReleasePublicationToMavenLocal

## Step 4: Push to Bintray
	
	$ ./gradlew bintrayUpload -PbintrayUser=BINTRAY_USER -PbintrayKey=BINTRAY_KEY -PdryRun=false
	
# All Together Now

Make sure BINTRAY_USER and BINTRAY_KEY are exported, then:

	$ ./dist.sh $VERSION

