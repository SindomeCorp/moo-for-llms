"title: toaststunt-map-iteration";
"dialect: toaststunt";
"source: original";
"license: MIT";
"topic: syntax";
"dialect_reason: Uses ToastStunt map literal syntax and key/value map iteration.";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

cache = ["north" -> 1, "south" -> 2];
rows = {};
for value, key in (cache)
  rows = {@rows, {key, value}};
endfor
return rows;
