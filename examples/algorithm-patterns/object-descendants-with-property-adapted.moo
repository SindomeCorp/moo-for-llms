"title: algorithm-object-descendants-with-property";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:descendants_with_property_suspended with permission from Sindome (www.sindome.org); permission policy and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: OBJ object, STR property";
"returns: LIST";
"notes: Shows recursive descendant filtering by direct property definition with yielding.";

":descendants_with_property(OBJ object, STR property) => LIST";
"Called by object-tree tools to find descendants that define a property.";
{object, property} = args;
$command_utils:suspend_if_needed(0);
matches = {};
if (`property_info(object, property) ! E_PROPNF => 0')
  matches = {object};
endif
for child in (children(object))
  matches = {@matches, @this:descendants_with_property(child, property)};
endfor
return matches;
