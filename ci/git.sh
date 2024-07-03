#!/usr/local/bin/bash

# vars
SOURCE_DIR=/crochet/src
SOURCE_URL=https://github.com/freebsd/freebsd-src.git
SOURCE_BRANCH=stable/13

# install git
echo "Installing git"
sudo pkg install -y git

# clone FreeBSD source
sudo git config --global http.version HTTP/1.1
if [ -d $SOURCE_DIR/.git ]; then 
    echo "Updating FreeBSD source at $SOURCE_DIR"
    pushd
    cd $SOURCE_DIR
    sudo git --verbose pull
    popd
else
    echo "Cloning FreeBSD source from $SOURCE_BRANCH branch $SOURCE_BRANCH into $SOURCE_DIR"
    sudo git clone $SOURCE_URL -b $SOURCE_BRANCH $SOURCE_DIR 
fi


