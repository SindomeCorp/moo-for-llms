"title: has-callable-verb-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:has_callable_verb with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: objects";
"callable: programmatic";
"args: OBJ object, STR verbname";
"returns: LIST|INT";
"notes: Shows walking parents to find an inherited executable verb.";

":has_callable_verb(OBJ object, STR verbname) => LIST|INT";
"Called by validation helpers to determine whether object or an ancestor defines an executable verb.";
{object, verbname} = args;
while (valid(object))
  if (`index(verb_info(object, verbname)[2], "x") ! E_VERBNF => 0' && verb_code(object, verbname))
    return {object};
  endif
  object = parent(object);
endwhile
return 0;
