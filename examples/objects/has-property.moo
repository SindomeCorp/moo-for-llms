" title: has-property";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: objects";
"callable: programmatic";
" provenance: adapted from $object_utils:has_property";

"Syntax:  has_property(OBJ, STR) => INT 0|1";
"";
"Does object have the specified property? Returns true if it is defined on the object or a parent.";
{object, prop} = args;
try
  property_info(object, prop);
  return 1;
except (E_PROPNF, E_INVIND, E_INVARG)
  return 0;
endtry
