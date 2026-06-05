"title: utility-xterm256-map-decorator-to-flag";
"dialect: core-specific";
"dialect_reason: Depends on the core-specific $xterm256 decorator flag convention.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:map_decorator_to_flag with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR decorator";
"returns: STR";
"notes: Shows a small explicit mapping table implemented as conditionals.";

":map_decorator_to_flag(STR decorator) => STR";
"Called by color-tag builders to encode decorator names into one-character flags.";
{decorator} = args;
if (decorator == "reset" || decorator == "normal")
  return "n";
elseif (decorator == "faint")
  return "t";
elseif (decorator == "bold")
  return "b";
elseif (decorator == "underline")
  return "u";
elseif (decorator == "italic")
  return "i";
elseif (decorator == "bgreset")
  return "r";
elseif (decorator == "blink")
  return "f";
endif
return "";
