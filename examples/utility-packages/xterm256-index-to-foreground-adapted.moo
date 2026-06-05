"title: utility-xterm256-index-to-foreground";
"dialect: core-specific";
"dialect_reason: Uses Sindome-specific $xterm256 color-name data and $ansi dynamic color verbs.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:index_to_foreground with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT color_index, ?STR text";
"returns: STR";
"notes: Shows dynamic color-verb dispatch from a numeric xterm color index.";

":index_to_foreground(INT color_index, ?STR text) => STR";
"Return an ANSI foreground color sequence, or wrap text in that foreground color when text is supplied.";
{color_index, ?text = ""} = args;
if (color_index > length(this.color_names))
  raise(E_INVARG, "invalid color index");
endif
color_name = this.color_names[color_index];
return text ? $ansi:(color_name)(text) | $ansi:(color_name)();
