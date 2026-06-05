"title: utility-object-utils-branches";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:branches with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ root";
"returns: LIST";
"notes: Shows iterative child traversal while keeping only objects that have children.";

":branches(OBJ root) => LIST";
"Called by tree-view helpers to return descendants that are themselves branch nodes.";
{root} = args;
branches = {root};
index = 1;
while (index <= length(branches))
  kids = children(branches[index]);
  if (kids)
    branches[index + 1..index] = kids;
    index = index + 1;
  else
    branches[index..index] = {};
  endif
endwhile
return branches;
