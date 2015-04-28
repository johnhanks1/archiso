#!/bin/bash
BUILDDIR="configs/releng"
set -e
set -x
pwd

# Initial checks
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

echo "Preparing build environment..."
cd $BUILDDIR
rm -rf work out
git fetch --all
git reset --hard
git checkout master
git reset --hard origin/master

chown -R root. .
echo "Building ISO (this may take several minutes)..."
set +e
./build.sh -v 2>&1 
chown -R jenkins. .
rc=$?
[[ $rc != 0 ]] && echo "An error has occurred while creating the ISO" && exit $rc

#echo "Updating PXE boot image on bloodwood..."
#ssh bloodwood "/root/update-arch-pxe"