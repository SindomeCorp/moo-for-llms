" title: sum";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $quinn_utils:sum";

":sum(LIST numbers) => total of all elements in `numbers' added together";
total = 0;
for number in (typeof(x = args[1]) == LIST ? x | args)
  total = total + number;
endfor
return total;
