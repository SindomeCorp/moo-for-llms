"title: utility-expanded-xterm-strip-tag-08";
"dialect: core-specific";
"dialect_reason: Uses or models the $xterm256 package as a core-specific utility API in this corpus.";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: STR";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":strip_tag_8(STR text) => STR";
"Called by utility package examples to demonstrate a focused helper pattern.";
{text} = args;
start = index(text, "<");
finish = index(text, ">");
if (start && finish > start)
  return text[1..start - 1] + text[finish + 1..$];
endif
return text;
