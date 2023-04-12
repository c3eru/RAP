#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/syberia-project/manifest.git -b 13.0 -g default,-mips,-darwin,-notdefault
git clone --depth 1 https://github.com/c3eru/local_manifest -b citrus-banana-1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source $CIRRUS_WORKING_DIR/config
timeStart

source build/envsetup.sh
export TZ=Asia/Jakarta
export KBUILD_BUILD_USER=$KBUILD_BUILD_USER
export KBUILD_BUILD_HOST=$KBUILD_BUILD_HOST
export BUILD_USERNAME=$KBUILD_BUILD_USER
export BUILD_HOSTNAME=$KBUILD_BUILD_HOST
lunch syberia_citrus-userdebug
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
mka bacon -j8  > reading

retVal=$?
timeEnd
statusBuild

# start 
