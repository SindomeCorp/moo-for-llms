"title: utility-expanded-object-callable-verb-03";
"dialect: portable";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: INT";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":has_callable_verb_3(OBJ object, STR verb_name) => INT";
"Called by utility package examples to demonstrate a focused helper pattern.";
{object, verb_name} = args;
info = `verb_info(object, verb_name) ! E_VERBNF, E_PERM => 0';
return info && index(info[2], "x") && 1;
