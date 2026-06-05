" title: guarded-list-loop";
" dialect: portable";
" source: original";
" license: MIT";
" topic: loops";
"callable: programmatic";

if (length(args) < 1 || typeof(args[1]) != LIST)
  return {};
endif

results = {};
for item in (args[1])
  results = {@results, tostr(item)};
endfor
return results;
