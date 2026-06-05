"title: algorithm-string-explode-preserve-empty";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:explode_all with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: STR text, ?STR separator";
"returns: LIST";
"notes: Shows splitting while preserving empty fields between consecutive separators.";

":explode_preserve_empty(STR text, ?STR separator) => LIST";
"Called by parsers that need empty fields instead of dropping them.";
{text, ?separator = " "} = args;
if (!separator)
  return E_INVARG;
endif
separator = separator[1];
if (text == "")
  return {""};
endif
if (text[$] != separator)
  text = text + separator;
  ended_with_separator = 0;
else
  ended_with_separator = 1;
endif
parts = {};
last_index = 1;
for position in ($string_utils:index_all(text, separator))
  parts = {@parts, text[last_index..position - 1]};
  last_index = position + 1;
endfor
if (ended_with_separator)
  parts = {@parts, ""};
endif
return parts;
