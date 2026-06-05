" title: assoc";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $list_utils:assoc";

"assoc(target,list[,index]) returns the first element of `list' whose own index-th element is target.  Index defaults to 1.";
"returns {} if no such element is found";
{target, thelist, ?indx = 1} = args;
for t in (thelist)
  $command_utils:sin(0);
  if (`t[indx] == target ! E_TYPE, E_RANGE => 0')
    if (typeof(t) == LIST && length(t) >= indx)
      return t;
    endif
  endif
endfor
return {};
