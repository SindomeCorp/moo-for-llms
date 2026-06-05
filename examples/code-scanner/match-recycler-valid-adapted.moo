"title: match-recycler-valid-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_scanner:match_recycler_valid with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: code-scanner";
"callable: programmatic";
"args: STR line";
"returns: INT";
"notes: Shows a scanner rule for $recycler:valid guards that may be missing negation in guard clauses.";

":match_recycler_valid(STR line) => INT";
"Called by code scanners to flag guard clauses that may need !$recycler:valid(...).";
{line} = args;
return match(line, "^[ ]*if (%$recycler:valid");
