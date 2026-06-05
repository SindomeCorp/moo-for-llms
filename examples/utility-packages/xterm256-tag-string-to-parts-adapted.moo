"title: utility-xterm256-tag-string-to-parts";
"dialect: core-specific";
"dialect_reason: Depends on the core-specific $xterm256 package and its fixed-width color tag format.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:tag_string_to_parts with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: LIST";
"notes: Shows splitting a string into text and fixed-width color-tag segments.";

":tag_string_to_parts(STR text) => LIST";
"Called by color-aware formatting helpers before measuring or transforming tagged strings.";
{text} = args;
parts = {};
pointer = 1;
part = "";
while (pointer <= length(text))
  if ($xterm256:detect_opening_tag(text[pointer..$]))
    if (part)
      parts = {@parts, part};
    endif
    parts = {@parts, text[pointer..pointer + $xterm256.COLOR_TAG_LENGTH - 1]};
    pointer = pointer + $xterm256.COLOR_TAG_LENGTH;
    part = "";
  else
    part = part + text[pointer];
    pointer = pointer + 1;
  endif
endwhile
if (part)
  parts = {@parts, part};
endif
return parts;
