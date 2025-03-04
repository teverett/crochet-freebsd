#
# SAMPLE CONFIGURATION
#
# Copy this to another file and use that when running Crochet, e.g.
#  $ sudo /bin/sh crochet.sh -c <myconfig>
#

# Note: Only board_setup is actually required, assuming /usr/src has
# suitable FreeBSD sources.  Everything else below is optional.

# REQUIRED: 
# Uncomment one to choose the default configuration for your board.
#
# THIS MUST BE THE FIRST LINE IN YOUR CONFIG.SH FILE!
#
# Don't see your board here?  board/NewBoardExample has details for
# how to add a new board definition.  If you need help, ask.  If you
# get it working, please consider contributing it.
#
# Read board/<board-name>/README for more details
# about configuring for your particular board.
#
#board_setup Alix
#board_setup BananaPi
#board_setup BananaPi-M3
#board_setup BeagleBone
#board_setup Cubieboard2
#board_setup Chromebook
#board_setup GenericI386
#board_setup NanoPi-NEO
#board_setup NanoPi-NEO2
#board_setup OrangePi-Plus2E
#board_setup PandaBoard
#board_setup Pine64
#board_setup RadxaRock
#board_setup RadxaRockLite
#board_setup Soekris
#board_setup RaspberryPi
#board_setup RaspberryPi2
board_setup RaspberryPi3
#board_setup RaspberryPiCM3L
#board_setup VersatilePB
#board_setup Wandboard
#board_setup ZedBoard
#board_setup Zybo
#

# Size of the disk image that will be built.  This is usually the same
# size as your memory card or disk drive, but it can be smaller.
# Each board setup above defines a default value, but the default is
# deliberately chosen to be just barely big enough to hold a minimal
# FreeBSD system.
#
# 'mb' = 10 ^ 6,  'gb' = 10 ^ 9, 'mib' = 2 ^ 20 and 'gib' = 2 ^ 30
#
# From 2%-10% of the flash on a typical memory card is
# reserved for the hardware controller, so the filesystem
# image size needs to be a bit smaller than the card size:
#
# Suggested: option ImageSize
#option ImageSize 100mb # for kernel-only images
#option ImageSize 1950mb # for 2 Gigabyte card
option ImageSize 3900mb # for 4 Gigabyte card

#
# How to Customize Your Build
#
# Crochet supports a variety of customization approaches:
#
# 1) "options" provide canned functionality.  If there is not
#   an option that provides what you want, consider contributing
#   a new one.  There's a template in option/Sample that explains
#   how to write a new one.  Note that board definitions can include
#   their own options; a few of the options below are only defined
#   for certain boards.
# 2) There are a large number of shell variables that control
#   how various internal features work.  A very few are described
#   below; you can find many more by skimming the source code.
#   (Variables beginning with '_' should not be touched.)
# 3) "overlay" files are simply copied to the image as-is.  Crochet
#   looks in a couple of standard places; you can just add the file
#   you want and it will get copied for you.
# 4) Functions beginning with "customize_" are provide for user
#   customization.  The default definitions are empty; feel free to
#   override them.  There are examples at the end of this file.
# 5) Crochet internally uses a "strategy list" of shell functions that
#   will be run.  The board definitions and options all add items to
#   the strategy list; you can also define your own functions and
#   add them directly to the strategy list using strategy_add.
#   Read the comments in lib/base.sh for details of how this works.
#
# If none of the above mechanisms support your requirements, ask
# and we'll see if we can add something else.
#

# "Growfs" adds a startup item that will use "growfs" to grow the
# UFS partition as large as it can.  This can be used to construct
# small (e.g., 1GB) images that can be copied onto larger (e.g., 32GB)
# media.  At boot, such images will automatically resize to fully
# utilize the larger media.  This should be considered experimental:
# FreeBSD's resize logic sometimes doesn't take effect until after a
# couple of extra reboots, which can make this occasionally perplexing
# to use.
#
#option Growfs

# Enable emailed status notifications.
# This can also be enabled via the -e command-line flag.
#
#option Email me@gmail.com

# Compress the final image.
# Takes an optional argument of xz or gzip. Defaults to xz.
#
#option CompressImage <xz|gzip>

# Same as 'CompressImage gzip'
#option GzipImage

# Create a user account with the specified username.
# Password will be the same as the user name.
#
option User crochet

# Takes a size argument (e.g., "768mb") and adds a swap file
# to the UFS partition of the indicated size.  This also adds
# the appropriate rc.conf and fstab entries to use the swap file.
# The size argument is required.  There are two optional arguments:
#   deferred - swap file will be created on first boot; this
#          works well in conjunction with Growfs above
#   file=/swapfile0 - Set the filename of the swap file.  The default
#          name is /swapfile0.
#
#option SwapFile <size> [deferred] [file=/swapfile0]

# Install packages from a repo
# First setup the repo with:
#
#option PackageInit http://pkg.example.com/armv7-svn/
#
# List one or many packages to be installed:
#
#option Package sudo nginx tmux

# Uses "portsnap" to download an up-to-date ports tree and
# install it on the image.
#
#option UsrPorts

# Copy the existing /usr/ports tree on the build system
# from <path> into the image.  The copy logic does not
# copy distfiles, work directories, or SVN checkout
# information.
#
#option UsrPorts <path>

# Copies the src tree that was used to build this image to /usr/src
# on the image.
#
#option UsrSrc

# Partition the system in a way similar to NanoBSD.
# The arguments and default values are:
#
#    + The device that the system will use to mount it's disks.
#      Default: /dev/mmcsd0
#    + The size of the OS partition(s).  Default: 1g
#    + The number of OS partitions.  Can be 1 or 2.  Default: 2
#    + The size of the /cfg partition.  Default: 32m
#
# This option will also install nanobsd specific tools into /root/bin/
#
#option NanoBSD '/dev/sd0' 1g
#option NanoBSD /dev/mmcsd0 1g 2 16m

# Enable NTP daemon
#option Ntpd

# Each board picks a default KERNCONF but you can override it.
#
#KERNCONF=MYCONF

# FreeBSD source that will be used for kernel, world, and ubldr.
# This directory doesn't need to exist yet.  When you run the script,
# it will tell you how to get appropriate sources into this directory.
# (I find FREEBSD_SRC=${TOPDIR}/src to be useful.)
#
#FREEBSD_SRC=/usr/src

# You will probably never override this, but you may need to
# understand it: WORKDIR holds all of the created and temporary files
# (in particular, the FreeBSD "obj" is redirected here).  It also
# holds a lot of log files: If something goes wrong, there's probably
# a record here.
#
# After successful world or kernel builds, a marker is put in this
# directory; subsequent runs of this script check for the marker and
# avoid rebuilding.  This makes it easy to tinker with the image
# layout and build without having to wait on all of FreeBSD to build
# every single time.
#
# In particular: If you need to do a clean build of everything from
# scratch, remove the contents of $WORKDIR first.
#
#WORKDIR=${TOPDIR}/work

# The name of the final disk image.
# This file will be as large as IMAGE_SIZE above, so make
# sure it's located somewhere with enough space.
#
# IMG specifies the whole path, and the source-specific variables are
# not available at this time.
# If IMGDIR is specified, then the image will be put into that directory.
# If IMGNAME is specified within single apostrophes, it will be evaluated,
# and the image named accordingly. This way, source-specific variables can
# be used as well.
# If the source version (git/svn/hg) is available, then the default image name
# is the following:
# FreeBSD-${TARGET_ARCH}-${FREEBSD_VERSION}-${KERNCONF}-${SOURCE_VERSION}
# If not, then:
# FreeBSD-${TARGET_ARCH}-${FREEBSD_MAJOR_VERSION}-${KERNCONF}.img
#IMG=${WORKDIR}/FreeBSD-${KERNCONF}.img
#IMGDIR=${WORKDIR}
#IMGNAME='FreeBSD-${TARGET_ARCH}-${FREEBSD_MAJOR_VERSION}-${KERNCONF}-${BOARDNAME}.img'

# Unset this to suppress installworld.  This is
# useful when experimenting with boot and kernel
# startup, since it greatly speeds up the image
# generation.  Set IMAGE_SIZE to 50 * MB or even smaller
# to really shorten your build/test cycles.
#
#FREEBSD_INSTALL_WORLD=y

# Extra arguments for FreeBSD build stages.
#
# Each board definition specifies certain options for the world and
# kernel builds.  Note that these are recorded in ${WORKDIR} when
# Crochet runs a build; subsequent Crochet runs will skip the
# corresponding build if the options are unchanged.
#
# You can add your own options to any single build phase:
#
#FREEBSD_BUILDWORLD_EXTRA_ARGS=""
#FREEBSD_INSTALLWORLD_EXTRA_ARGS=""
#FREEBSD_BUILDKERNEL_EXTRA_ARGS=""
#FREEBSD_INSTALLKERNEL_EXTRA_ARGS=""

# You can specify options for both buildworld and installworld:
#
#FREEBSD_WORLD_EXTRA_ARGS=""

# You can specify options for both buildkernel and installkernel.
#
#FREEBSD_KERNEL_EXTRA_ARGS=""

# You can specify options used for all four of the above:
#
#FREEBSD_EXTRA_ARGS=""

# Build jobs.  The number of make jobs to run in parallel.
# Defaults to: $(sysctl -n hw.ncpu)
#WORLDJOBS="4"
#KERNJOBS="4"

# You can specify a custom src.conf or make.conf; the defaults are:
#
#SRCCONF="/dev/null"
#__MAKE_CONF="/dev/null"

# For example, I find each of the following quite useful at times:
#
#FREEBSD_EXTRA_ARGS="-DNO_CLEAN"
#FREEBSD_KERNEL_EXTRA_ARGS="-DKERNFAST"



# OVERLAY FILES
#
# Most customization simply consists of putting extra
# files onto the image.
#
# After the board logic has populated the FreeBSD system, the contents
# of ${BOARDDIR}/overlay, ${TOPDIR}/overlay, and ${WORKDIR}/overlay
# are copied on top of the image in that order.  For example, you can
# put a custom passwd or fstab file into ${TOPDIR}/overlay/etc and it
# will be picked up automatically.  Similarly, if you need to
# dynamically create a certain file, you can do that here (config.sh
# is a /bin/sh file and you can use arbitrary shell logic) and put the
# result into ${WORKDIR}/overlay


# STANDARD customize_ FUNCTIONS
#
# There are a few standard functions beginning with customize_
# that are specifically provided for you to override.  These
# are never defined by Crochet.
#
# Most board definitions work with two partitions (for some boards,
# these are in different image files):
#  * A boot partition holds the various boot loaders.  This varies
#    significantly by board.
#  * A FreeBSD partition holds the FreeBSD world (and usually kernel).
#    Board definitions should keep this as standard as possible.
#
# The following functions are run after the default board setup has
# run, so you can feel free to delete or rearrange files on the image
# as you see fit.
#
# WARNING: Unlike some other system-building scripts, these do *not*
# run in a chroot or jail.  (It can't because we're cross-building.)
# For example, if you want to add an account, be sure to modify
# etc/passwd and not /etc/passwd!
#
# Some useful shell variables:
#   ${WORKDIR} is the full path to the 'work' directory
#       which you can use for intermediate files
#   ${TOPDIR} is the current directory in which crochet is located
#
# The lib/*.sh files also define a number of functions
# that you may find useful here.
#
# # Runs after boot partition is built.
# # The current working directory is at the root of the mounted
# # boot partition.
#customize_boot_partition ( ) {
#}
#
# Note that the following runs even if FREEBSD_INSTALL_KERNEL
# and FREEBSD_INSTALL_WORLD are not enabled.
#
# # Runs after FreeBSD partition is built and populated.
# # The current working directory is at the root of the mounted
# # freebsd partition.
#customize_freebsd_partition ( ) {
#}

# For example, here's one way to add an entry to the default /etc/fstab:
#
#customize_freebsd_partition ( ) {
#  echo "md /tmp mfs rw,noatime,-s30m 0 0" >> etc/fstab
#}

# If you can't do what you want with the above, try this:
# customize_post_unmount is called after the image is fully created
# and unmounted.  $1 is the filename of the constructed image file.
# You can remount, resize partitions, change partition options, etc.
# If you do anything interesting with this, please let me know.
# I've used it for things like compressing the image file
# and for creating distribution bundles that have a disk image
# and other associated files.


# Adding Strategy Items
#
# Internally, Crochet's configuration works by constructing
# several lists of shell functions to run.  These lists
# comprise Crochet's "strategy".  Once the configuration is
# complete, these lists are sorted and the shell functions
# in them are run to actually carry out the image creation.
#
# You can add new items to the strategy from directly within
# your config.sh file.  This allows you to alter almost
# any part of Crochet's internal operation.  However, be aware
# that the strategy mechanism may change in future versions
# of Crochet, so you should generally only use this for
# things that are difficult or impossible to do in any other
# way.  Please let the Crochet maintainers know about this;
# they are always looking for more information about how
# Crochet is being used.
#
