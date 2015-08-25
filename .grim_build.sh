#!/bin/bash

set -eu

. /opt/golang/go1.4.2/bin/go_env.sh

export GOPATH="$(pwd)/go"

cd "./$CLONE_PATH"

curl -L https://cpanmin.us/ -o cpanm
chmod +x cpanm

./cpanm --installdeps .

perl Makefile.PL && make test dist
if [ "$GH_EVENT_NAME" == "push" -a "$GH_TARGET" == "master" ]; then
    go get github.com/MediaMath/part
    VERSION=$(perl -Ilib -MRose::DBx::Object::MakeMethods::BCrypt -e 'print $Rose::DBx::Object::MakeMethods::BCrypt::VERSION')
    LOCAL_ARCHIVE=Rose-DBx-Object-MakeMethods-BCrypt-$VERSION.tar.gz
    part -verbose -credentials=$HOME/artifactory.mediamath.com_creds -h="https://artifactory.mediamath.com/artifactory" -r=libs-release-local -g=com.mediamath -a=rose-dbx-object-makemethods-bcrypt -v=$VERSION $LOCAL_ARCHIVE
fi
