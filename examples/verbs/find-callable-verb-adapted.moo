"title: find-callable-verb-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:find_callable_verb_named with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR name, ?INT start";
"returns: INT";
"notes: Shows scanning local verb definitions for a name match with the executable flag set.";

":find_callable_verb_named(OBJ object, STR name, ?INT start) => INT";
"Called by code utilities to find a directly defined executable verb matching a name.";
{object, name, ?start = 1} = args;
for i in [start..length(verbs(object))]
  info = verb_info(object, i);
  if (index(info[2], "x") && $code_utils:verbname_match(info[3], name))
    return i;
  endif
endfor
return 0;
