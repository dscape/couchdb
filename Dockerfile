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
run useradd -d /var/lib/couchdb couchdb
run chown -R couchdb /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb /usr/local/etc/couchdb
run chmod 0770 /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb
run chmod 664 /usr/local/etc/couchdb/*.ini
run chmod 775 /usr/local/etc/couchdb/*.d
run rm /etc/logrotate.d/couchdb /etc/init.d/couchdb 2&>1
run ln -s /usr/local/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb
run ln -s /usr/local/etc/init.d/couchdb  /etc/init.d/couchdb
run update-rc.d couchdb defaults
run service couchdb start

expose 5984
