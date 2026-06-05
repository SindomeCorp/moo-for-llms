"title: map-vs-list-labeling";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP type, empty map literal [], and map indexing.";
"source: original";
"license: MIT";
"topic: dialect-classification";
"callable: programmatic";
"args: STR key, MIXED value";
"returns: MAP";
"notes: Shows why square-bracket map syntax should be labeled ToastStunt-specific.";

":store_map_value(STR key, MIXED value) => MAP";
"Called by dialect examples to demonstrate ToastStunt map syntax.";
{key, value} = args;
data = [];
data[key] = value;
return data;
