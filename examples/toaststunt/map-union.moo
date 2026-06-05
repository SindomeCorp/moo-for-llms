" title: map-union";
" dialect: toaststunt";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: maps";
"callable: programmatic";
" provenance: adapted from $map_utils:union";
" dialect_reason: uses ToastStunt MAP type, empty map literal [], mapkeys(), maphaskey(), and map indexing assignment";

":union(MAP map1[, MAP map2..]) => MAP of combined elements";
"  squishes maps togethers";
result = [];
for MAP in (args)
  for key in (mapkeys(MAP))
    $command_utils:sin(0);
    value = MAP[key];
    if (!maphaskey(result, key))
      result[key] = value;
      continue;
    endif
    existing = result[key];
    if (typeof(existing) == LIST && typeof(value) != LIST)
      result[key] = {@existing, value};
      continue;
    elseif (typeof(existing) == LIST)
      result[key] = $set_utils:union(existing, value);
      continue;
    elseif (typeof(existing) == MAP)
      result[key] = this:union(existing, value);
      continue;
    endif
    result[key] = result[key] + MAP[key];
  endfor
endfor
return result;
