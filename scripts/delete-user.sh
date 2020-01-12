#!!/bin/sh

aws mq delete-user \
  --broker-id ${1} \
  --username ${2}
