const wellknown = require("wellknown");
const fs = require("fs");
const simplify = require("@turf/simplify");

const features = [];

const dig = function(a) {
  if (!Array.isArray(a) || a.length === 0) return;
  if (Array.isArray(a[0])) {
    a.forEach(b => dig(b));
  } else {
    a[0] = parseFloat(a[0].toFixed(5));
    a[1] = parseFloat(a[1].toFixed(5));
  }
};

JSON.parse(fs.readFileSync(process.argv[2], "UTF-8")).results.bindings.forEach(a => {
  const key = a.code.value.substring(0, 5) + a.label.value;
  let j = wellknown.parse(a.wkt.value.replace(/^<[^>]*> /, ""));
  dig(j.coordinates);
  j = simplify(j, {
    tolerance: 0.0002,
    mutated: true
  });
  j.id = key;
  j.properties = {
    code: a.code.value,
    label: a.label.value
  };
  if (a.households) j.properties.households = a.households.value;
  if (a.year) j.properties.year = a.year.value;
  features.push(j);
});

console.log(JSON.stringify({
  type: "FeatureCollection",
  features: features
}));
