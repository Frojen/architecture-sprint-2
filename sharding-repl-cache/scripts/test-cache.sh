#!/bin/bash

echo 1-й запрос:
curl -o /dev/null -s -w 'Total: %{time_total}s\n'  http://localhost:8080/helloDoc/users
echo
echo 2-й запрос:
curl -o /dev/null -s -w 'Total: %{time_total}s\n'  http://localhost:8080/helloDoc/users
