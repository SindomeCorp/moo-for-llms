"title: ellipsize-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:ellipsize with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: strings";
"callable: programmatic";
"args: STR text, INT max_length";
"returns: STR|ERR";
"notes: Shows explicit argument validation before slicing a string.";

":ellipsize(STR text, INT max_length) => STR|ERR";
"Called by table and summary renderers to shorten long display text.";
{text, max_length} = args;
if (!text)
  return text;
elseif (max_length < 4)
  return E_INVARG;
elseif (length(text) <= max_length)
  return text;
endif
return tostr(text[1..max_length - 3], "...");
