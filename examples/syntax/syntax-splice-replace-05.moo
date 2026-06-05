"title: syntax-splice-replace-05";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":splice_replace_5(@MIXED values) => MIXED";
"called by syntax tests to replace one list position.";
{items, index, value} = args;
items[index..index] = {value};
return items;
