"title: utility-object-utils-opaque-properties";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:opaque_properties with permission from Sindome (www.sindome.org); source-control metadata removed and short refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows filtering inherited clear properties while handling E_PERM and E_INVARG.";

":opaque_properties(OBJ object) => LIST";
"Return properties from $object_utils:all_properties(object) that are not clear inherited properties.";
{object} = args;
result = $object_utils:all_properties(object);
for prop in (result)
  try
    if (is_clear_property(object, prop))
      result = setremove(result, prop);
    endif
  except (E_PERM)
    result = setremove(result, prop);
  except (E_INVARG)
    " Ignore properties that are not valid on this object.";
  endtry
endfor
return result;
