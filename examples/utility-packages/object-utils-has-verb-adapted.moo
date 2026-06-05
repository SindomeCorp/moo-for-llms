"title: utility-object-utils-has-verb";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:has_verb with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: LIST|INT";
"notes: Shows walking inheritance with verb_info() and inline error catching.";

":has_verb(OBJ object, STR verb_name) => LIST|INT";
"Return {defining_object} when object or an ancestor defines verb_name; otherwise return 0.";
{object, verb_name} = args;
while (E_VERBNF == (info = `verb_info(object, verb_name) ! E_VERBNF, E_INVARG'))
  object = parent(object);
endwhile
return info ? {object} | 0;
