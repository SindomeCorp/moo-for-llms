"title: utility-code-utils-corify-object";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:corify_object with permission from Sindome (www.sindome.org); raw root-object access replaced with a passed-in registry.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, LIST registry";
"returns: STR";
"notes: Shows corified-reference lookup without hardcoding raw object numbers.";

":corify_object(OBJ object, LIST registry) => STR";
"Return a $name from registry rows of {name, object}, or tostr(object) when no row matches.";
{object, registry} = args;
for row in (registry)
  if (length(row) >= 2 && row[2] == object)
    return "$" + row[1];
  endif
endfor
return tostr(object);
