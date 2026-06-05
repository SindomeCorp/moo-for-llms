"title: utility-object-utils-has-readable-prop";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:has_readable_prop with permission from Sindome (www.sindome.org); core-specific builtin-property fallback removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR property";
"returns: INT";
"notes: Shows using property_info() to check read permission without prechecking every property.";

":has_readable_prop(OBJ object, STR property) => INT";
"Called by display helpers before reading optional object properties.";
{object, property} = args;
try
  info = property_info(object, property);
  return index(info[2], "r") != 0;
except (E_PROPNF)
  return 0;
endtry
