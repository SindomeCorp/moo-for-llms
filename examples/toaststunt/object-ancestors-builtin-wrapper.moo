" title: object-ancestors-builtin-wrapper";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: objects";
"callable: programmatic";
" provenance: adapted from $object_utils:ancestors";
" dialect_reason: uses ToastStunt ancestors() builtin for the single-object path";

"Usage:  ancestors(object[, object...])";
"Return a list of all ancestors of the object(s) in args, with no duplicates.";
"If called with a single object, the result will be in order ascending up the inheritance hierarchy.  If called with multiple objects, it probably won't.";
ret = {};
if (length(args) == 1)
  return ancestors(args[1]);
endif
for o in (args)
  what = o;
  while (valid(what = parent(what)))
    $command_utils:suspend_if_needed(0);
    ret = setadd(ret, what);
  endwhile
endfor
return ret;
