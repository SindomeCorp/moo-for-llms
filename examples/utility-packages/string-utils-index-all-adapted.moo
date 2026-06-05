"title: utility-string-utils-index-all";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:index_all with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text, STR pattern";
"returns: LIST|ERR";
"notes: Shows collecting all substring positions while avoiding broad catches.";

":index_all(STR text, STR pattern) => LIST|ERR";
"Called by parsers to find every occurrence of a substring in one pass.";
{text, pattern} = args;
if (typeof(text) != STR || typeof(pattern) != STR)
  return E_TYPE;
elseif (!pattern)
  return E_INVARG;
endif
positions = {};
offset = 0;
while (place = index(text[offset + 1..$], pattern))
  positions = {@positions, place + offset};
  offset = place + offset + length(pattern) - 1;
endwhile
return positions;
