"title: algorithm-string-progress-bar";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:progress_bar with permission from Sindome (www.sindome.org); ANSI/player preference checks and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: INT current, INT maximum, INT width";
"returns: STR";
"notes: Shows proportional gauge calculation and fixed-width text rendering.";

":plain_progress_bar(INT current, INT maximum, INT width) => STR";
"Called by status displays to render a simple proportional progress bar.";
{current, maximum, width} = args;
if (maximum <= 0)
  return E_INVARG;
endif
filled = toint(tofloat(current) / tofloat(maximum) * tofloat(width));
if (filled < 0)
  filled = 0;
elseif (filled > width)
  filled = width;
endif
return tostr("[", $string_utils:space(filled, "|"), $string_utils:space(width - filled, "."), "]");
