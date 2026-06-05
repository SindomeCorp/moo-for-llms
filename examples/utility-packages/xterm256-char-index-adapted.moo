"title: utility-xterm256-char-index";
"dialect: core-specific";
"dialect_reason: Uses Sindome-specific $xterm256 color tag parsing helpers.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:char_index with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: INT";
"notes: Shows skipping leading xterm color tags before returning the visible character index.";

":char_index(STR text) => INT";
"Return the index of the first visible character after leading xterm color tags, or 0 if no visible character exists.";
{text} = args;
original_length = length(text);
while (text)
  try
    if ($xterm256:detect_opening_tag(text))
      text = text[$xterm256.color_tag_length + 1..$];
      continue;
    endif
  except (E_RANGE)
    return 0;
  endtry
  return original_length - length(text) + 1;
endwhile
return 0;
