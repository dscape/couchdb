# CouchDB | Stud
#
# This base image bundles `stud` and `CouchDB`
#
# VERSION  0.0.0
from       ubuntu
maintainer Nuno Job "nunojobpinto@gmail.com"

#
# adds the installation scripts to the image
#
# same as a copy of the opt/install folder in this repo
# to /opt/install
# 
add ./opt /opt

#
# define an helper function to run command in verbose mode
# so that docker does not invalidate cache on each run
#
run touch ~/.profile
run cat /opt/install/dscape/couchdb/preserve_caches >> \
 ~/.profile

#
# run are steps that are run to create the image
#

#
# update/upgrade apt
#
run $(preserve_caches /opt/install/dscape/couchdb/apt-update)

#
# running scripts in individual scripts makes your scm happy
# and is much more manageable, etc
#
# however, bummer is that it invalidates caches
#


#
# install couchdb dependencies
#
run /opt/install/dscape/couchdb/couchdb-deps

#
# build couchdb
#
run /opt/install/dscape/couchdb/couchdb-build

#
# config couchdb
#
run /opt/install/dscape/couchdb/couchdb-config

#
# install stud dependencies
#
run /opt/install/dscape/couchdb/stud-deps

#
# build stud
#
run /opt/install/dscape/couchdb/stud-build

#
# config stud
#
run /opt/install/dscape/couchdb/stud-config

#
# generate a pem file with a random private key and
# a self signed certificate using that key
#
# before going to production you should add your own
# pem file for your own domain
#
run /opt/install/dscape/couchdb/stud-generate-self-signed-pem

#
# manually link files
#
add ./etc /etc
add ./usr /usr

#
# update those defaults
#
run update-rc.d stud defaults
run update-rc.d couchdb defaults

#
# what port to expose
#
expose 6984

#
# `cmd` will be run when someone docker runs an image
# e.g. after docker pull dscape/couchdb
#

#
# generate a new pem file so that you don't end up using the one
# that comes bundled in the image
#
cmd /opt/install/dscape/couchdb/stud-generate-self-signed-pem

#
# start stud and couchdb
#
cmd /opt/install/dscape/couchdb/start
