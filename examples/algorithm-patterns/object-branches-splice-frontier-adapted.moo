"title: algorithm-object-branches-splice-frontier";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:branches with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-in-condition avoided.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: OBJ object";
"returns: LIST";
"notes: Shows keeping internal nodes while removing leaves from a traversal frontier.";

":branch_descendants(OBJ object) => LIST";
"Called by object-tree tools to collect descendants that themselves have children.";
{object} = args;
frontier = {object};
index = 1;
while (index <= length(frontier))
  kids = children(frontier[index]);
  if (kids)
    frontier[index + 1..index] = kids;
    index = index + 1;
  else
    frontier[index..index] = {};
  endif
endwhile
return frontier;
