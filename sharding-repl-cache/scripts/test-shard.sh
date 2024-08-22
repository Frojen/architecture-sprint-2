#!/bin/bash

docker compose exec -T shard1a mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2a mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
