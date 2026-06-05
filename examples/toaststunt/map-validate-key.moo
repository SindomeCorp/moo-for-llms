" title: map-validate-key";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: maps";
"callable: programmatic";
" provenance: adapted from $map_utils:validate_map_key";
" dialect_reason: uses ToastStunt MAP type, maphaskey(), and map indexing";

{mapVal, keyname, ?label = "argument", ?datatype = -1, ?class = $nothing} = args;
if (typeof(mapVal) != MAP)
  raise(E_INVARG, label + " must be a map");
elseif (!maphaskey(mapVal, keyname))
  raise(E_INVARG, label + " must contain '" + keyname + "'");
elseif (datatype >= 0 && typeof(mapVal[keyname]) != datatype)
  raise(E_INVARG, label + "." + keyname + " must be of type " + $quinn_utils:type_name(datatype));
elseif ($recycler:valid(class) && !$object_utils:isa(mapVal[keyname], class))
  raise(E_INVARG, tostr(label, ".", keyname, " must be a descedent of ", class));
endif
