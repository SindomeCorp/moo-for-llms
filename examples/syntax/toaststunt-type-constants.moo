"title: toaststunt-type-constants";
"dialect: toaststunt";
"source: original";
"license: MIT";
"topic: syntax";
"dialect_reason: Uses ToastStunt MAP, WAIF, ANON, and BOOL type constants.";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

map_type = MAP;
waif_type = WAIF;
anon_type = ANON;
bool_type = BOOL;
truth_type = typeof(1 == 1);
return {map_type, waif_type, anon_type, bool_type, truth_type};
