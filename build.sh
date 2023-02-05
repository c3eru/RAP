#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/SuperiorOS/manifest.git -b thirteen -g default,-mips,-darwin,-notdefault
git clone --depth 1 https://github.com/c3eru/local_manifest -b ssos-spes .repo/local_manifests
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
lunch superior_spes-userdebug
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
m bacon -j8  > reading

retVal=$?
timeEnd
statusBuild

# start
