"title: toaststunt-map-default-list";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP literal, map indexing, and E_RANGE fallback.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: MAP buckets, STR key, ANY value";
"returns: MAP";
"notes: Shows appending to a list stored inside a native ToastStunt map.";

":map_default_list(MAP buckets, STR key, ANY value) => MAP";
"Called by ToastStunt grouping helpers to append values under a key.";
{buckets, key, value} = args;
if (typeof(buckets) != MAP)
  buckets = [];
endif
bucket = `buckets[key] ! E_RANGE => {}';
buckets[key] = {@bucket, value};
return buckets;
