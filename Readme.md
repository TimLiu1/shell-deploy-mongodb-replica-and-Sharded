### shell to quickly deploy mongodb replica set and sharding

### Environment [install mongodb](https://docs.mongodb.com/manual/tutorial/)

```
 mongodb version >= 3.4 
```
### Replica Set Deployment
```
bash replica-set.sh
```

###### check deploy status
```
mongo --port 27017
rs.status()
rs.config()
```
all data store in ~/srv/mongodb/replicaset



### Deploy a Sharded Cluster

```
bash sharded-cluster.sh
```

config ports 30000~30002

shard_one ports 30003~30005

shard_two ports 30006~30008

mongos port 30009

shard db: db_test

shard collection: student

shard key: age

###### check deploy status
```
mongo --port 30009
sh.status()
```

all data store in ~/srv/mongodb




