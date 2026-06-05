"title: utility-string-utils-is-integer";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:is_integer with permission from Sindome (www.sindome.org); dead code after return removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: INT";
"notes: Shows a compact regular-expression numeric check.";

":is_integer(STR text) => INT";
"Called by parsers before converting user-provided text with toint().";
{text} = args;
if (typeof(text) != STR)
  return 0;
endif
return match(text, "^ *[-+]?[0-9]+ *$") != 0;
