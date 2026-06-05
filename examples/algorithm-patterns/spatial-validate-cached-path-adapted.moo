"title: algorithm-spatial-validate-cached-path";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $spatial:validate_cached_path with permission from Sindome (www.sindome.org); player/access checks, short refs, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST graph, MIXED start, MIXED destination, LIST path";
"returns: INT";
"notes: Shows recursively validating a cached path one step at a time against current graph edges.";

":validate_cached_path(LIST graph, MIXED start, MIXED destination, LIST path) => INT";
"Called by path-cache helpers before trusting a stored route.";
{graph, start, destination, path} = args;
$command_utils:suspend_if_needed(0);
if (start == destination)
  return 1;
elseif (!path)
  return 0;
endif
row = $list_utils:assoc(start, graph);
if (!row)
  return 0;
endif
step_name = path[1];
next_node = 0;
for edge in (row[2])
  if (edge[2] == step_name)
    next_node = edge[1];
    break;
  endif
endfor
if (!next_node)
  return 0;
elseif (next_node == destination)
  return 1;
elseif (length(path) == 1)
  return 0;
endif
return this:(verb)(graph, next_node, destination, path[2..$]);
