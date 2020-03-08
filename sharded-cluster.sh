
#init config server
address='config'
echo $address
mkdir -p ~/srv/mongodb/$address/rs0-0  ~/srv/mongodb/$address/rs0-1 ~/srv/mongodb/$address/rs0-2
mkdir -p ~/srv/mongodb/$address/log0-0  ~/srv/mongodb/$address/log0-1  ~/srv/mongodb/$address/log0-2
mongod  --configsvr --replSet config --port 30000 --dbpath ~/srv/mongodb/$address/rs0-0  --logpath ~/srv/mongodb/$address/log0-0//mongo --fork
mongod  --configsvr --replSet config --port 30001 --dbpath ~/srv/mongodb/$address/rs0-1  --logpath ~/srv/mongodb/$address/log0-1/mongo --fork
mongod  --configsvr  --replSet config --port 30002 --dbpath ~/srv/mongodb/$address/rs0-2  --logpath ~/srv/mongodb/$address/log0-2/mongo --fork
mongo --port 30000 --eval 'rsconf = {"_id": "config","configsvr": true, "members": [{ "_id": 0,"host": "127.0.0.1:30000"},{"_id": 1,"host": "127.0.0.1:30001"},{"_id": 2,"host": "127.0.0.1:30002"}]};rs.initiate(rsconf);'



# init shard one

address='shard_one'
echo $address
mkdir -p ~/srv/mongodb/$address/rs0-0  ~/srv/mongodb/$address/rs0-1 ~/srv/mongodb/$address/rs0-2
mkdir -p ~/srv/mongodb/$address/log0-0  ~/srv/mongodb/$address/log0-1  ~/srv/mongodb/$address/log0-2
mongod  --shardsvr --replSet $address --port 30003 --dbpath ~/srv/mongodb/$address/rs0-0  --logpath ~/srv/mongodb/$address/log0-0//mongo --fork
mongod  --shardsvr --replSet $address --port 30004 --dbpath ~/srv/mongodb/$address/rs0-1  --logpath ~/srv/mongodb/$address/log0-1/mongo --fork
mongod  --shardsvr  --replSet $address --port 30005 --dbpath ~/srv/mongodb/$address/rs0-2  --logpath ~/srv/mongodb/$address/log0-2/mongo --fork
mongo --port 30003 --eval 'rsconf = {"_id": "shard_one", "members": [{ "_id": 0,"host": "127.0.0.1:30003"},{"_id": 1,"host": "127.0.0.1:30004"},{"_id": 2,"host": "127.0.0.1:30005"}]};rs.initiate(rsconf);'



#init shard two

address='shard_two'
echo $address
mkdir -p ~/srv/mongodb/$address/rs0-0  ~/srv/mongodb/$address/rs0-1 ~/srv/mongodb/$address/rs0-2
mkdir -p ~/srv/mongodb/$address/log0-0  ~/srv/mongodb/$address/log0-1  ~/srv/mongodb/$address/log0-2
mongod  --shardsvr --replSet $address --port 30006 --dbpath ~/srv/mongodb/$address/rs0-0  --logpath ~/srv/mongodb/$address/log0-0//mongo --fork
mongod  --shardsvr --replSet $address --port 30007 --dbpath ~/srv/mongodb/$address/rs0-1  --logpath ~/srv/mongodb/$address/log0-1/mongo --fork
mongod  --shardsvr  --replSet $address --port 30008 --dbpath ~/srv/mongodb/$address/rs0-2  --logpath ~/srv/mongodb/$address/log0-2/mongo --fork
mongo --port 30006 --eval 'rsconf = {"_id": "shard_two", "members": [{ "_id": 0,"host": "127.0.0.1:30006"},{"_id": 1,"host": "127.0.0.1:30007"},{"_id": 2,"host": "127.0.0.1:30008"}]};rs.initiate(rsconf);'


# init mongos
address='mongos'
echo $address
mkdir -p ~/srv/mongodb/$address/rs0-0 
mkdir -p ~/srv/mongodb/$address/log0-0 
mongos --port 30009 --configdb config/127.0.0.1:30000,127.0.0.1:30001,127.0.0.1:30002   --logpath ~/srv/mongodb/$address/log0-0 --fork
mongo --port 30009 --eval 'sh.addShard("shard_one/127.0.0.1:30003,127.0.0.1:30004,127.0.0.1:30005");sh.addShard("shard_two/127.0.0.1:30006,127.0.0.1:30007,127.0.0.1:30008");sh.enableSharding("db_test");sh.shardCollection("db_test.student", { age: 1 } )'
