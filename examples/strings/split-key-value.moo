"title: split-key-value";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: STR text";
"returns: LIST|ERR";
"notes: Shows index-based string splitting without regular expressions.";

":split_key_value(STR text) => LIST|ERR";
"Called by parsers for simple key=value settings; returns {key, value} or E_INVARG.";
{text} = args;
equals = index(text, "=");
if (!equals)
  return E_INVARG;
endif
key = $string_utils:trim(text[1..equals - 1]);
value = $string_utils:trim(text[equals + 1..$]);
return {key, value};
