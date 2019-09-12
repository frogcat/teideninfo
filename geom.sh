#!/usr/bin/env bash

code=$1
echo $1

raw=geom.tmp
out=docs/geom.json

if [ ! -e "${raw}" ] ; then
  echo ${raw}

curl -v -H 'Accept: application/sparql-results+json' --data-urlencode 'query@-' http://data.e-stat.go.jp/lod/sparql/alldata/query > ${raw} << EOS
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX ic: <http://imi.go.jp/ns/core/rdf#>
prefix sdmx-dimension: <http://purl.org/linked-data/sdmx/2009/dimension#>
prefix estat-measure: <http://data.e-stat.go.jp/lod/ontology/measure/>
prefix cd-dimension: <http://data.e-stat.go.jp/lod/ontology/crossDomain/dimension/>

select * where {
  ?s a <http://data.e-stat.go.jp/lod/terms/smallArea/SmallAreaCode> ;
     dcterms:identifier ?code ; geo:hasGeometry/geo:asWKT ?wkt ; rdfs:label ?label.
  filter strstarts(?code,"12") .
  optional {
    ?x estat-measure:households ?households;
    sdmx-dimension:refArea ?s ;
    cd-dimension:timePeriod ?year .
  }
}
EOS

else
  echo "Skip: ${raw} already exists"
fi

node geom.js ${raw} > ${out}
