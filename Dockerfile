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
run sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini

#
# stud
#
run apt-get install libev4 libssl-dev libev-dev curl -y
run cd /opt/install && git clone git://github.com/bumptech/stud.git && cd stud && make && make install
run mkdir /var/run/stud && mkdir /usr/local/var/run/stud && mkdir /usr/local/etc/stud && touch /usr/local/etc/stud/stud.conf && touch /usr/local/etc/stud/stud.pem && useradd -d /var/lib/_stud _stud && chown _stud: /usr/local/etc/stud/stud.pem && chown _stud: /var/run/stud && chown -R _stud: /usr/local/var/run/stud /usr/local/etc/stud && chmod 0770 /usr/local/var/run/stud/ && chmod 664 /usr/local/etc/stud/*.conf && chmod 600 /usr/local/etc/stud/stud.pem && mkdir /etc/stud && touch /etc/stud/stud.conf && touch /etc/init.d/stud && chmod +x /etc/init.d/stud

#
# generate a pem file for stud
# self signed certificate with randomly generated key
#
# in production use "yourdomain"
#
run cd ~ && mkdir generate_keys && cd generate keys && ssh-keygen -t rsa -N "" -f ~/generate_keys/id_stud && openssl req -new -key id_stud -out server_stud.csr -subj "/C=PT/ST=NY/L=NY/O=Stud Proxy/OU=IT Department/CN=foo.org" && openssl x509 -req -days 365 -in server_stud.csr -signkey /root/.ssh/id_stud -out server_stud.crt && cat id_stud > /usr/local/etc/stud/stud.pem && cat server_stud.crt >> /usr/local/etc/stud/stud.pem 

#
# manually link files
#
add ./ /

#
# update those defaults
#
update-rc.d stud defaults
run update-rc.d couchdb defaults


#
# what port to expose
#
expose 6984

# `cmd` will be run when someone docker runs an image
# e.g. after docker pull dscape/couchdb
cmd /bin/bash -c "stud --ssl -n 2 -s -f "[*]:6984" -b "[127.0.0.1]:5984" /usr/local/etc/stud/stud.pem && couchdb -a /usr/local/etc/couchdb/default.ini -a /usr/local/etc/couchdb/local.ini -b -r 5 -p /usr/local/var/run/couchdb/couchdb.pid -R"

