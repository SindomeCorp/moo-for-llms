" title: toaststunt-map-type-check";
" dialect: toaststunt";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" dialect_reason: uses ToastStunt MAP type and empty map literal []";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (!this.cache)";
"   this.cache = [];";
" endif";
" fixed:";
if (typeof(this.cache) != MAP)
  this.cache = [];
endif

return this.cache;
