"title: toaststunt-json-decode-map-cache";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt parse_json() and MAP values.";
"source: original";
"license: MIT";
"topic: toaststunt";
"callable: programmatic";
"args: STR payload";
"returns: MAP|ERR";
"notes: Shows parsing JSON into a ToastStunt value and requiring a MAP result.";

":decode_map_cache(STR payload) => MAP|ERR";
"Called by ToastStunt-only cache importers that require JSON objects.";
{payload} = args;
value = `parse_json(payload) ! E_INVARG => E_INVARG';
if (value == E_INVARG)
  return value;
endif
return typeof(value) == MAP ? value | E_TYPE;
