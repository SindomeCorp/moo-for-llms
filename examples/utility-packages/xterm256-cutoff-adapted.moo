"title: utility-xterm256-cutoff";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $xterm256 ANSI color utility package.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:cutoff_suspended with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text, INT start, INT end";
"returns: STR";
"notes: Shows a core-specific ANSI-aware substring wrapper with E_TYPE fallback.";

":cutoff(STR text, INT start, INT end) => STR";
"Return an ANSI-aware substring by delegating location calculation to this:_cutoff_locs.";
{text, start, end} = args;
try
  {real_start, real_end} = this:_cutoff_locs(text, start, end, 0, 0);
  return text[real_start..real_end];
except (E_TYPE)
  return text;
endtry
