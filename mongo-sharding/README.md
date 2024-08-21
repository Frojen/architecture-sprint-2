# pymongo-api

## Как запустить

Запустить mongodb и приложение

```shell
docker compose up -d
```

Инициализировать шарды

```shell
./scripts/shard-init.sh
```

Заполнить тестовыми данными

```shell
./scripts/fill-data.sh
```


## Как проверить

Общее количество документов по шардам

```shell
./scripts/test-shard.sh
```

Общее количество документов

```shell
curl http://localhost:8080/helloDoc/count
```

Общая информация по конфигурации

```shell
curl http://localhost:8080/
```