"title: syntax-toaststunt-map-literal";
"dialect: toaststunt";
"source: original";
"license: MIT";
"topic: syntax";
"dialect_reason: Uses ToastStunt map literal syntax and map indexing.";
"callable: programmatic";
"args: none";
"returns: MAP";
"notes: Compile-tested against a live MOO scratch verb.";

cache = ["count" -> 1, "label" -> "ready"];
cache["count"] = cache["count"] + 1;
return cache;
