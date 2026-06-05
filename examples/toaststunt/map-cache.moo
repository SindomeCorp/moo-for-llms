" title: map-cache";
" dialect: toaststunt";
" source: original";
" license: MIT";
" topic: maps";
"callable: programmatic";
" dialect_reason: uses ToastStunt MAP type, empty map literal [], maphaskey(), and map indexing assignment";

if (typeof(this.cache) != MAP)
  this.cache = [];
endif

key = args[1];
if (!maphaskey(this.cache, key))
  this.cache[key] = this:compute_value(key);
endif

return this.cache[key];
