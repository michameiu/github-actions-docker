#!/bin/bash

ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$(cat $ACCESS_TOKEN_FILE)


echo "Bearer ${HELLODA} ${ACCESS_TOKEN}"

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

pwd

echo "https://github.com/${ORGANIZATION} - ${REG_TOKEN}"

./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --ephemeral --labels $LABELS

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
