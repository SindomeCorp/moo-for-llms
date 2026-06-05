"title: utility-string-utils-name-of-single";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:name_of_single with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST items, ?INT width";
"returns: LIST";
"notes: Shows filtering object values and formatting stable display labels.";

":name_of_single(LIST items, ?INT width) => LIST";
"Return display labels for the valid objects in items.";
{items, ?width = 20} = args;
result = {};
object_width = length(tostr(toint(max_object()))) + 1;
for item in (items)
  $command_utils:suspend_if_needed(0);
  if (typeof(item) == OBJ && valid(item))
    label = tostr($string_utils:left(item.name, width * -1), " (", $string_utils:left(item, object_width), ")");
    result = setadd(result, label);
  endif
endfor
return result;
