const fetch = require("node-fetch");
const iconv = require("iconv-lite");

const entry = process.argv[2];

const teideninfo = function(filename) {
  return fetch("http://teideninfo.tepco.co.jp/html/" + filename).then(a => a.buffer()).then(a => iconv.decode(a, "Shift_JIS"));
};

teideninfo(entry).then(a => {
  const result = [];
  const promises = a.split('"').filter(b => b.endsWith("00.html") && !b.startsWith("00")).map(b => {
    return teideninfo(b).then(c => {
      let lvl1 = null;
      let lvl2 = null;
      let lvl3 = null;
      let val = null;
      c.split("\n").forEach(d => {
        if (d.indexOf("tiiki_coment1") !== -1) {
          const token = d.split(/[<> ]/);
          lvl1 = token.find(a => a.match(/[都道府県]$/));
          lvl2 = token.find(a => a.match(/[市区町村]$/));
        } else if (d.match(/^.*bo_lv3_ck">(.+)<.*$/)) {
          lvl3 = RegExp.$1;
        } else if (d.match(/^.*bo_lv3_tk">(.+)<.*$/)) {
          val = RegExp.$1;
          if (lvl3 !== "&nbsp;" && val !== "停電軒数") {
            result.push([b, lvl1, lvl2, lvl3, val]);
          }
        }
      });
      return true;
    });
  });

  Promise.all(promises).then(() => {
    console.log(JSON.stringify(result, null, 2));
  });
});
