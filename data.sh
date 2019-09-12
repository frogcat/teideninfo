#!/usr/bin/env bash

code=$1

now=`date +%Y%m%d%H%m`
html=${code}000000000.html

node main.js ${html} > docs/data.${now}.json
cp docs/data.${now}.json docs/data.json
