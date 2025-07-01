# exit(1) if any subcommands fail
set -e

PROJECT_NAME=
SCHEME_IOS=
SCHEME_MACOS=


usage() { echo "Usage: $0 -p ProjectName [-i IosSchemeName] [-m MacosSchemeName]" 1>&2; exit 1; }

# explanation of args	https://stackoverflow.com/a/34531699/355753
while getopts "p:i:m:t:," o; do
    case "${o}" in
        p)
            PROJECT_NAME=${OPTARG}
            ;;
        i)
            SCHEME_IOS=${OPTARG}
            ;;
        m)
            SCHEME_MACOS=${OPTARG}
            ;;
        #*)
        #    usage
        #    ;;
    esac
done
shift $((OPTIND-1))



if [ -z "${PROJECT_NAME}" ]; then
	echo "Missing -p ProjectName"
	exit 1
fi


if [ -z "${BUILT_PRODUCTS_DIR}" ]; then
	echo "Missing env var BUILT_PRODUCTS_DIR, using arg2($2)"
	BUILT_PRODUCTS_DIR=$2
fi

if [ -z "${BUILT_PRODUCTS_DIR}" ]; then
	echo "env argument BUILT_PRODUCTS_DIR is empty"
	exit 1
fi

# build temporary dir
BUILD_DIR="./build"
#	use BUILT_PRODUCTS_DIR for PopAction_Apple which gets first stdout output
BUILD_UNIVERSAL_DIR=${BUILT_PRODUCTS_DIR}

BUILDPATH_IOS="${BUILD_DIR}/${PROJECT_NAME}_Ios"
BUILDPATH_SIM="${BUILD_DIR}/${PROJECT_NAME}_IosSimulator"
BUILDPATH_MACOS="${BUILD_DIR}/${PROJECT_NAME}_Macos"
BUILDPATH_TVOS="${BUILD_DIR}/${PROJECT_NAME}_Tvos"

#SCHEME_IOS=${PROJECT_NAME}_IosFramework
#SCHEME_MACOS=${PROJECT_NAME}_MacosFramework

PRODUCT_NAME_UNIVERSAL="${PROJECT_NAME}.xcframework"

CONFIGURATION="Release"
DESTINATION_IOS="generic/platform=iOS"
DESTINATION_MACOS="generic/platform=macOS"

# filled in if built
FRAMEWWORK_PATH_IOS=
FRAMEWWORK_PATH_IOSSIMULATOR=
FRAMEWWORK_PATH_MACOS=
FRAMEWWORK_PATH_TVOS=

# build archived frameworks
# see https://github.com/NewChromantics/PopAction_BuildApple/blob/master/index.js for some battle tested CLI options
echo "Building sub-framework archives..."

if [ ! -z "${SCHEME_IOS}" ]; then
	xcodebuild archive -scheme ${SCHEME_IOS} -archivePath $BUILDPATH_IOS SKIP_INSTALL=NO -sdk iphoneos -configuration ${CONFIGURATION} -destination ${DESTINATION_IOS}
fi

if [ ! -z "${SCHEME_MACOS}" ]; then
	xcodebuild archive -scheme ${SCHEME_MACOS} -archivePath $BUILDPATH_MACOS SKIP_INSTALL=NO  -configuration ${CONFIGURATION} -destination ${DESTINATION_MACOS}
	# need to pull this out of the output...
	FRAMEWWORK_PATH_MACOS="-framework ${BUILDPATH_MACOS}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}.framework"
fi

#xcodebuild archive -scheme ${PROJECT_NAME}_IosSimulator -archivePath $BUILDPATH_SIM SKIP_INSTALL=NO -sdk iphonesimulator
#xcodebuild archive -scheme ${PROJECT_NAME}_Macos -archivePath $BUILDPATH_MACOS SKIP_INSTALL=NO
#xcodebuild archive -scheme ${PROJECT_NAME}_Tvos -archivePath $BUILDPATH_TVOS SKIP_INSTALL=NO



# bundle together
echo "Building xcframework..."
#xcodebuild -create-xcframework -framework ${BUILDPATH_IOS}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Ios.framework -framework ${BUILDPATH_SIM}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Ios.framework -framework ${BUILDPATH_OSX}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Osx.framework -output ./build/${FULL_PRODUCT_NAME}
#xcodebuild -create-xcframework -framework ${BUILDPATH_IOS}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Ios.framework -output ${BUILD_UNIVERSAL_DIR}/${PRODUCT_NAME_UNIVERSAL}
#xcodebuild -create-xcframework -framework ${BUILDPATH_IOS}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Ios.framework -framework ${BUILDPATH_SIM}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Ios.framework -framework ${BUILDPATH_OSX}.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}_Osx.framework -output ${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}
xcodebuild -create-xcframework ${FRAMEWWORK_PATH_IOS} ${FRAMEWWORK_PATH_IOSSIMULATOR} ${FRAMEWWORK_PATH_MACOS} ${FRAMEWWORK_PATH_TVOS} -output ${BUILD_UNIVERSAL_DIR}/${PRODUCT_NAME_UNIVERSAL}

echo "xcframework ${PRODUCT_NAME_UNIVERSAL} built successfully"

# output meta for https://github.com/NewChromantics/PopAction_BuildApple
# which matches a regular scheme output
echo "FULL_PRODUCT_NAME=${PRODUCT_NAME_UNIVERSAL}"
echo "BUILT_PRODUCTS_DIR=${BUILD_UNIVERSAL_DIR}"

# show in finder
open --reveal ${BUILD_UNIVERSAL_DIR}/${PRODUCT_NAME_UNIVERSAL}

# output meta for github
# gr: I think my apple action will pull this out? if we use FULL_PRODUCT_NAME?
#echo PRODUCT_NAME=${PRODUCT_NAME_UNIVERSAL} >> GITHUB_OUTPUT
#echo PRODUCT_PATH=${BUILD_DIR} >> GITHUB_OUTPUT
