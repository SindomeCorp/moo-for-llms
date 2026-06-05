"title: algorithm-object-descendants-breadth-first";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from the MOO-code branch of $object_utils:descendants with permission from Sindome (www.sindome.org); ToastStunt builtin shortcut and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows breadth-first descendant traversal using children() instead of the ToastStunt descendants() builtin.";

":descendants_breadth_first(OBJ object) => LIST";
"Called by object-tree tools to collect all descendants portably.";
{object} = args;
result = children(object);
index = 1;
while (index <= length(result))
  $command_utils:suspend_if_needed(0);
  kids = children(result[index]);
  if (kids)
    result = {@result, @kids};
  endif
  index = index + 1;
endwhile
return result;
