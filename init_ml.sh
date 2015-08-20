#!/bin/bash

function wait_until_started {
  for i in `seq 1 20`; do
    STATUS_CODE=`curl -m 2 -w %{http_code} -s -o /dev/null http://localhost:8001/admin/v1/timestamp 2>/dev/null`
    if [ $STATUS_CODE == "200" ]; then
      echo "MarkLogic Server started!"
      return 0
    fi
    echo "MarkLogic Server not yet started..."
    sleep 2
  done
  return 1
}

echo "Check if MarkLogic Server is running"
wait_until_started
STARTED_EXIT_CODE=$?

if [ $STARTED_EXIT_CODE == "1" ]; then
  echo "MarkLogic server not started..."
  exit 1
else
  RESPONSE=`curl -s -S -X POST -d "" "http://localhost:8001/admin/v1/init" 2>/dev/null`
fi



