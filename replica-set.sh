
address='replicaset'
echo $address
mkdir -p ~/srv/mongodb/rs0-0  ~/srv/mongodb/$replicaset/rs0-1 ~/srv/mongodb/$replicaset/rs0-2
mkdir -p ~/srv/mongodb/log0-0  ~/srv/mongodb/$replicaset/log0-1  ~/srv/mongodb/$replicaset/log0-2
mongod --replSet rs0 --port 27017 --dbpath ~/srv/mongodb/$replicaset/rs0-0  --logpath ~/srv/mongodb/$replicaset/log0-0/mongo --fork
mongod --replSet rs0 --port 27018 --dbpath ~/srv/mongodb/$replicaset/rs0-1  --logpath ~/srv/mongodb/$replicaset/log0-1/mongo --fork
mongod --replSet rs0 --port 27019 --dbpath ~/srv/mongodb/$replicaset/rs0-2  --logpath ~/srv/mongodb/$replicaset/log0-2/mongo --fork
mongo  --eval 'rsconf = {id: "rs0",members: [{ _id: 0,host: "127.0.0.1:27017"},{_id: 1,host: "127.0.0.1:27018"},{_id: 2,host: "127.0.0.1:27019"}]};rs.initiate(rsconf)'