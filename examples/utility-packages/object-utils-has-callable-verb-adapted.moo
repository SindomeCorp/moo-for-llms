"title: utility-object-utils-has-callable-verb";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:has_callable_verb with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: LIST|INT";
"notes: Shows walking inheritance to find a callable x-permission verb.";

":has_callable_verb(OBJ object, STR verb_name) => LIST|INT";
"Return {defining_object} when object or an ancestor has callable verb_name; otherwise return 0.";
{object, verb_name} = args;
while (valid(object))
  info = `verb_info(object, verb_name) ! E_VERBNF => 0';
  if (info && index(info[2], "x"))
    return {object};
  endif
  object = parent(object);
endwhile
return 0;
