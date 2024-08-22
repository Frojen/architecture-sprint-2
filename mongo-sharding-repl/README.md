# pymongo-api

## Как запустить

Запустить mongodb и приложение

```shell
docker compose up -d
```

Инициализировать шарды и реплики

```shell
docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
)
EOF

docker compose exec -T shard1a mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1a:27018" },
        { _id : 1, host : "shard1b:27021" },
        { _id : 2, host : "shard1c:27022" },
      ]
    }
)
EOF

docker compose exec -T shard2a mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2a:27019" },
        { _id : 1, host : "shard2b:27023" },
        { _id : 2, host : "shard2c:27024" },
      ]
    }
)
EOF

docker compose exec -T router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1a:27018")
sh.addShard( "shard1/shard1b:27021")
sh.addShard( "shard1/shard1c:27022")
sh.addShard( "shard2/shard2a:27019")
sh.addShard( "shard2/shard2b:27023")
sh.assShard( "shard2/shard2c:27024")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF
```

Заполнить тестовыми данными

```shell
docker compose exec -T router mongosh --port 27020 --quiet <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

```


## Как проверить

Общее количество документов по шардам

```shell
docker compose exec -T shard1a mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2a mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

Общее количество документов по репликам

```shell
docker compose exec -T shard1a mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1b mongosh --port 27021 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1c mongosh --port 27022 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2a mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2b mongosh --port 27023 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2c mongosh --port 27024 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

Общее количество документов

```shell
curl http://localhost:8080/helloDoc/count
```

Общая информация по конфигурации

```shell
curl http://localhost:8080/
```