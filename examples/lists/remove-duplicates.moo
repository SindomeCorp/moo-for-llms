" title: remove-duplicates";
" dialect: portable";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $list_utils:remove_duplicates";

"remove_duplicates(list) => list as a set, i.e., all repeated elements removed.";
out = {};
for x in (args[1])
  out = setadd(out, x);
endfor
return out;
