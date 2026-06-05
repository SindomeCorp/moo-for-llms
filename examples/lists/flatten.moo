" title: flatten";
" dialect: portable";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $list_utils:flatten";

":flatten(LIST list_of_lists) => LIST of all lists in given list `flattened'";
newlist = {};
for elm in (args[1])
  if (typeof(elm) == LIST)
    newlist = {@newlist, @this:flatten(elm)};
  else
    newlist = {@newlist, elm};
  endif
endfor
return newlist;
