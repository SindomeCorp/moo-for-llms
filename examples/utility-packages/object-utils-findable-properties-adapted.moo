"title: utility-object-utils-findable-properties";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:findable_properties with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows collecting readable or caller-owned properties through an inheritance chain.";

":findable_properties(OBJ object) => LIST";
"Return properties readable by caller_perms() or owned by caller_perms() on object and its ancestors.";
{object} = args;
result = {};
who = caller_perms();
while (valid(object))
  if (object.r || who == object.owner || who.wizard)
    result = {@properties(object), @result};
  endif
  object = parent(object);
endwhile
return result;
