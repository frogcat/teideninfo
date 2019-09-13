#!/usr/bin/env bash

code=$1

now=`date +%Y%m%d%H%M`
html=${code}000000000.html

echo $now

node main.js ${html} > docs/data.${now}.json
cp docs/data.${now}.json docs/data.json

find . -name 'data.*.json' | sed -ne 's#./docs/##p' > docs/data.txt
