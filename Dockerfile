# CouchDB
#
# VERSION  0.0.0
from       ubuntu
maintainer Nuno Job "nunojobpinto@gmail.com"

# make sure the package repository is up to date
run echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

run apt-get update
run apt-get upgrade
run apt-get install git make gcc build-essential wget -y
run apt-get install -y erlang-dev erlang-manpages erlang-base-hipe erlang-eunit erlang-nox erlang-xmerl erlang-inets libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

run mkdir /opt/install && cd /opt/install && wget http://mirrors.fe.up.pt/pub/apache/couchdb/source/1.3.1/apache-couchdb-1.3.1.tar.gz
run cd /opt/install && tar xvzf apache-couchdb-1.3.1.tar.gz
run cd /opt/install/apache-couchdb-* && ./configure && make && make install
run service couchdb start

expose 5984
