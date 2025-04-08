#!/bin/bash

WALLET=UQCIbB9o9uMNgdR-y0UlL3q9K8aU3T1uUISC2DqK8-8IxKWd
POOL=stratum+tcp://us-rvn.2miners.com:6060
WORKER=$(hostname)

cd /app

./t-rex -a kawpow -o $POOL -u $WALLET.$WORKER -p x --api-bind-http 0.0.0.0:8000
