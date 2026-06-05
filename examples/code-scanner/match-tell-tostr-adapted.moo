"title: match-tell-tostr-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_scanner:match_tell_tostr with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: code-scanner";
"callable: programmatic";
"args: STR line";
"returns: INT";
"notes: Shows a scanner rule for redundant player:tell(tostr(...)) patterns when tell already stringifies arguments on many cores.";

":match_tell_tostr(STR line) => INT";
"Called by code scanners to flag player:tell(tostr(...)) patterns.";
{line} = args;
return match(line, ".*:tell(.*tostr(");
