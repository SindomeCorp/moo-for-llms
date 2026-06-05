"title: specific-catch-normalize";
"dialect: portable";
"source: original";
"license: MIT";
"topic: errors";
"callable: programmatic";
"args: STR text, INT default";
"returns: INT";
"notes: Shows normalizing input with a specific inline error catch instead of catching ANY.";

":toint_or_default(STR text, INT default) => INT";
"Called by parsers to convert optional numeric text with a caller-provided fallback.";
{text, default} = args;
return `toint(text) ! E_INVARG, E_TYPE => default';
