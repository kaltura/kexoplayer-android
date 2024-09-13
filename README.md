
ExoPlayer in com.kaltura namespace

# Build Steps

## Step 1: Download and unpack Media3 ExoPlayer

	$ curl -L https://github.com/androidx/media/archive/$VERSION.tar.gz | tar -xz
	
This will create a directory media-rVERSION.

## Step 2: Prepare the sources

	$ ./prepare.sh EXOPLAYER_INPUT_DIR OUTPUT_DIR
	
## Step 3: Build

	$ ./gradlew publishToMavenLocal

## Step 4: Push to Bintray
	
	$ ./gradlew bintrayUpload -PbintrayUser=BINTRAY_USER -PbintrayKey=BINTRAY_KEY -PdryRun=false
	
# All Together Now

Make sure BINTRAY_USER and BINTRAY_KEY are exported, then:

	$ ./dist.sh $VERSION

