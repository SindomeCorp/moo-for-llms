"title: algorithm-object-leaves-splice-frontier";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:leaves with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-in-condition avoided.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows replacing an internal node with its children until only leaves remain.";

":leaf_descendants(OBJ object) => LIST";
"Called by object-tree tools to collect descendants that have no children.";
{object} = args;
frontier = {object};
index = 1;
while (index <= length(frontier))
  kids = children(frontier[index]);
  if (kids)
    frontier[index..index] = kids;
  else
    index = index + 1;
  endif
endwhile
return frontier;
