"title: utility-xterm256-length";
"dialect: core-specific";
"dialect_reason: Uses Sindome-specific $xterm256 color-tag utilities.";
"source: approved-generic-sindome";
"provenance: Adapted from $xterm256:length with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MIXED ...";
"returns: INT";
"notes: Shows measuring visible string length after stripping color tags.";

":length(MIXED ...) => INT";
"Return visible length of text after removing xterm color tags.";
return length(this:strip_tags(tostr(@args)));
