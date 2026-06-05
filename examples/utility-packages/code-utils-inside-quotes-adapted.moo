"title: utility-code-utils-inside-quotes";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:inside_quotes with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: INT";
"notes: Shows scanning escaped quotes when transforming code-like strings.";

":inside_quotes(STR text) => INT";
"Called by substitution helpers to avoid rewriting text inside double quotes.";
{text} = args;
quoted = 0;
for index in [1..length(text)]
  if (text[index] == "\"" && (!quoted || text[index - 1] != "\\"))
    quoted = !quoted;
  endif
endfor
return quoted;
