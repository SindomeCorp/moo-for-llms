" title: map-dot-flatten";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: maps";
"callable: programmatic";
" provenance: adapted from $map_utils:dot_flatten";
" dialect_reason: uses ToastStunt MAP type, mapkeys(), and map indexing";

":dot_flatten(MAP data) => LIST of keys dot-delimited";
{data} = args;
results = {};
maps = {{"", data}};
while (maps)
  {current, maps} = $list_utils:pop(maps);
  for key in (mapkeys(current[2]))
    $command_utils:sin(0);
    composite = current[1] ? tostr(current[1], ".", key) | tostr(key);
    value = current[2][key];
    if (typeof(value) == MAP)
      maps = {@maps, {composite, value}};
    endif
    results = {@results, composite};
  endfor
endwhile
return results;
