" title: contains";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: objects";
"callable: programmatic";
" provenance: adapted from $object_utils:contains";

"$object_utils:contains(obj1, obj2) -- does obj1 contain obj2?";
"";
"Return true iff obj2 is under obj1 in the containment hierarchy; that is, if obj1 is obj2's location, or its location's location, or ...";
{loc, what} = args;
while (valid(what))
  what = what.location;
  if (what == loc)
    return valid(loc);
  endif
endwhile
return 0;
