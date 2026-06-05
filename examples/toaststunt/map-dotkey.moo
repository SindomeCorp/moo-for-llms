" title: map-dotkey";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: maps";
"callable: programmatic";
" provenance: adapted from $map_utils:dotkey";
" dialect_reason: uses ToastStunt MAP type and map indexing";

":dotkey(MAP my_map, STR key_string) => MIXED";
"allow multi-depth access to string keys with dot notation";
"usage: ;$map_utils:dotkey([\"a\" -> [\"b\" -> [\"c\" -> \"abc!\"], \"e\" -> \"e!\"]], \"a.b.c\") => \"abc!\"";
{my_map, key_string} = args;
if (typeof(my_map) != MAP)
  raise(E_INVARG, "my_map is not a map");
elseif (typeof(key_string) != STR)
  raise(E_INVARG, "key_string is not a string");
elseif (!key_string)
  raise(E_INVARG, "key_string can not be empty");
endif
keys = explode(key_string, ".");
temp = my_map;
for key in (keys)
  temp = temp[key[1] == "#" ? toobj(key) | key];
endfor
return temp;
