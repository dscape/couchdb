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
# same as a recursive copy of the opt/ folder in this repo
# to /opt
# 
add ./opt /opt

#
# run are steps that are run to create the image
#

#
# update/upgrade apt
#
run /opt/apt-update

#
# install couchdb dependencies
#
run /opt/couchdb-deps

#
# build couchdb
#
run /opt/couchdb-build

#
# config couchdb
#
run /opt/couchdb-config

#
# install stud dependencies
#
run /opt/stud-deps

#
# build stud
#
run /opt/stud-build

#
# config stud
#
run /opt/stud-config

#
# generate a pem file with a random private key and
# a self signed certificate using that key
#
# before going to production you should add your own
# pem file for your own domain
#
run /opt/stud-generate-self-signed-pem

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
cmd /opt/stud-generate-self-signed-pem

#
# start stud and couchdb
#
cmd /opt/start
