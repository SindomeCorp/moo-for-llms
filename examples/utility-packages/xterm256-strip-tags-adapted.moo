"title: utility-xterm256-strip-tags";
"dialect: core-specific";
"dialect_reason: Depends on the core-specific $xterm256 package and its fixed-width color tag format.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:strip_tags with permission from Sindome (www.sindome.org); short refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: STR";
"notes: Shows removing fixed-width xterm256 tags while preserving non-tag text.";

":strip_tags(STR text) => STR";
"Called by plain-text output paths before sending ANSI-tagged text to clients that should not see tags.";
{text} = args;
opening = $xterm256.escape + "(";
if (!index(text, opening))
  return text;
endif
current = 1;
while (start = index(text[current..$], opening))
  start = start + current - 1;
  tag = text[start..min($, start + $xterm256.COLOR_TAG_LENGTH - 1)];
  text = strsub(text, tag, "");
  current = start;
endwhile
return text;
