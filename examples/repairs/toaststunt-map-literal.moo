" title: toaststunt-map-literal";
" dialect: toaststunt";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" dialect_reason: uses ToastStunt MAP type and empty map literal []";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" cache = {};";
" if (typeof(cache) != MAP)";
"   cache = {};";
" endif";
" fixed:";
cache = {};
if (typeof(cache) != MAP)
  cache = [];
endif

return cache;
