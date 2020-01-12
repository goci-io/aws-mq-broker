#!/bin/sh

consoleAccess=${4:-"no-console-access"}

aws mq create-user \
  --broker-id ${1} \
  --username ${2} \
  --password ${3} \
  --${consoleAccess} \
  --groups ${5}
