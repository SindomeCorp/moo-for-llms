"title: utility-object-utils-all-properties";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:all_properties with permission from Sindome (www.sindome.org); VMS metadata removed and ToastStunt call_function() avoided for portability.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows walking ancestors and collecting readable property names.";

":all_properties(OBJ object) => LIST";
"Return readable properties defined on object and its ancestors.";
{object} = args;
result = {};
while (valid(object))
  result = {@`properties(object) ! E_PERM => {}', @result};
  object = parent(object);
endwhile
return result;
