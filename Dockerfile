# CouchDB | Stud
#
# VERSION  0.0.0
from       ubuntu
maintainer Nuno Job "nunojobpinto@gmail.com"

#
# make sure the package repository is up to date
#
run echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

#
# update our ubuntu box
#
run apt-get update
run apt-get upgrade
run apt-get install git make gcc build-essential wget -y
run apt-get install -y erlang-dev erlang-manpages erlang-base-hipe erlang-eunit erlang-nox erlang-xmerl erlang-inets libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

#
# `run` is run to build the image
#

#
# couchdb
#
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
run sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini

#
# stud
#
run apt-get install libev4 libssl-dev libev-dev curl -y
run cd /opt/install && git clone git://github.com/bumptech/stud.git && cd stud && make && make install
run mkdir /var/run/stud
run mkdir /usr/local/var/run/stud
run mkdir /usr/local/etc/stud
run touch /usr/local/etc/stud/stud.conf
run touch /usr/local/etc/stud/stud.pem
run useradd -d /var/lib/_stud _stud
run chown _stud: /usr/local/etc/stud/stud.pem
run chown _stud: /var/run/stud
run chown -R _stud: /usr/local/var/run/stud /usr/local/etc/stud
run chmod 0770 /usr/local/var/run/stud/
run chmod 664 /usr/local/etc/stud/*.conf
run chmod 600 /usr/local/etc/stud/stud.pem
run mkdir /etc/stud
run touch /etc/stud/stud.conf
run rm /etc/init.d/stud
run touch /etc/init.d/stud
run chmod +x /etc/init.d/stud
update-rc.d stud defaults

#
# manually link files
#
add ./etc/default/stud /etc/default/stud
add ./etc/init.d/stud /etc/init.d/stud
add ./usr/local/etc/couchdb/local.ini /usr/local/etc/couchdb/local.ini
add ./usr/local/etc/stud/stud.conf /usr/local/etc/stud/stud.conf
add ./usr/local/etc/stud/stud.pem /usr/local/etc/stud/stud.pem

#
# what port to expose
#
expose 6984

# `cmd` will be run when someone docker runs an image
# e.g. after docker pull dscape/couchdb
cmd /bin/bash -c "service stud start && couchdb -a /usr/local/etc/couchdb/default.ini -a /usr/local/etc/couchdb/local.ini -b -r 5 -p /usr/local/var/run/couchdb/couchdb.pid -R"

