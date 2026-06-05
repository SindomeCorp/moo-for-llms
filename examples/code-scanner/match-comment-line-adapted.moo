"title: match-comment-line-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_scanner:match_comment with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: code-scanner";
"callable: programmatic";
"args: STR line";
"returns: INT";
"notes: Shows identifying preserved MOO string-literal comments as code-scanner input.";

":match_comment(STR line) => INT";
"Called by code scanners to detect MOO string-literal comments.";
{line} = args;
return match(line, "^[ ]*\"");
