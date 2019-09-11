const wellknown = require("wellknown");
const fs = require("fs");

const features = [];

JSON.parse(fs.readFileSync(process.argv[2], "UTF-8")).results.bindings.forEach(a => {
  const key = a.code.value.substring(0, 5) + a.label.value;
  const j = wellknown.parse(a.wkt.value.replace(/^<[^>]*> /, ""));
  j.id = key;
  features.push(j);
});

console.log(JSON.stringify({
  type: "FeatureCollection",
  features: features
}));
