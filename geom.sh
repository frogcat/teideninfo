#!/usr/bin/env bash

code=$1
echo $1

raw=geom.tmp
out=docs/geom.json

if [ ! -e "${raw}" ] ; then
  echo ${raw}

curl 'http://data.e-stat.go.jp/lod/sparql/alldata/query' -H 'Pragma: no-cache' -H 'Origin: http://data.e-stat.go.jp' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: ja,en-US;q=0.9,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: application/sparql-results+json,*/*;q=0.9' -H 'Cache-Control: no-cache' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: _pk_ref.7.2beb=%5B%22%22%2C%22%22%2C1568195960%2C%22https%3A%2F%2Fwww.google.com%2F%22%5D; _pk_id.7.2beb=213a0b2061e8a348.1561355858.25.1568195962.1568195960.' -H 'Connection: keep-alive' -H 'Referer: http://data.e-stat.go.jp/lod/sparql/' --data 'query=PREFIX+geo%3A+%3Chttp%3A%2F%2Fwww.opengis.net%2Font%2Fgeosparql%23%3E%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+ic%3A+%3Chttp%3A%2F%2Fimi.go.jp%2Fns%2Fcore%2Frdf%23%3E%0Aselect+*+where+%7B%0A++%3Fs+a+%3Chttp%3A%2F%2Fdata.e-stat.go.jp%2Flod%2Fterms%2FsmallArea%2FSmallAreaCode%3E+%3B%0A+++++dcterms%3Aidentifier+%3Fcode+%3B+geo%3AhasGeometry%2Fgeo%3AasWKT+%3Fwkt+%3B+rdfs%3Alabel+%3Flabel.%0A++filter+strstarts(%3Fcode%2C%2212%22)%0A%7D' --compressed --insecure > ${raw}

else
  echo "Skip: ${raw} already exists"
fi

node geom.js ${raw} > ${out}
