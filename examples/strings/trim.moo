" title: trim";
" dialect: portable";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: strings";
"callable: programmatic";
" provenance: adapted from $string_utils:trim";

":trim (string [, space]) -- remove leading and trailing spaces";
"";
"`space' should be a character (single-character string); it defaults to \" \".  Returns a copy of string with all leading and trailing copies of that character removed.  For example, $string_utils:trim(\"***foo***\", \"*\") => \"foo\".";
{string, ?space = " "} = args;
m = match(string, tostr("[^", space, "]%(.*[^", space, "]%)?%|$"));
return string[m[1]..m[2]];
