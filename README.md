# CouchDB  + Stud Docker Container

A simple container to run CouchDB on port 6984 behind stud proxy

## Use

```
docker pull dscape/couchdb
docker run -d dscape/couchdb
```

## Configure

The file you most likely want to change is the pem file. It currently includes a self signed certificate generate when the image is created /usr/local/etc/stud/stud.pem.

The workflow is something like:

```
id=$(docker run dscape/couchdb <somecommandthatupdatespemfile>)
test $(docker wait $id) -eq 0
docker commit $id dscape/couchdb > /dev/null
```

If you have a private docker registry, feel free to publish as yourdomain/couchdb including the keys so you can just reuse and update