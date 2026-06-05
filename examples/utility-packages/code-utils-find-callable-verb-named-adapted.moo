"title: utility-code-utils-find-callable-verb-named";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:find_callable_verb_named with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR name, ?INT start";
"returns: INT";
"notes: Shows scanning directly defined verbs for a matching executable verb name.";

":find_callable_verb_named(OBJ object, STR name, ?INT start) => INT";
"Return the first directly defined executable verb number matching name, or 0 if absent.";
{object, name, ?start = 1} = args;
for verb_number in [start..length(verbs(object))]
  info = verb_info(object, verb_number);
  if (index(info[2], "x") && this:verbname_match(info[3], name))
    return verb_number;
  endif
endfor
return 0;
