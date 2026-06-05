"title: algorithm-spatial-depth-first-near-path";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $dynamic_room:find_if_near and $elevator:find_if_near with permission from Sindome (www.sindome.org); room-specific checks, cache hooks, short refs, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST graph, MIXED current, MIXED destination, ?LIST current_path, ?LIST exhausted, ?LIST shortest_path, ?INT depth";
"returns: LIST";
"notes: Shows recursive depth-first path search with exhausted-node tracking, depth limit, and shortest-path replacement.";

":find_near_path(LIST graph, MIXED current, MIXED destination, ?LIST current_path, ?LIST exhausted, ?LIST shortest_path, ?INT depth) => LIST";
"Called by pathing helpers to search nearby graph nodes without revisiting exhausted nodes.";
{graph, current, destination, ?current_path = {}, ?exhausted = {}, ?shortest_path = {}, ?depth = 0} = args;
if (current == destination)
  if (!shortest_path || length(current_path) < length(shortest_path))
    return current_path;
  endif
  return shortest_path;
endif
if (depth > 9)
  return shortest_path;
endif
row = $list_utils:assoc(current, graph);
if (!row)
  return shortest_path;
endif
for edge in (row[2])
  {next_node, step_name} = edge;
  if (next_node in exhausted)
    continue;
  endif
  exhausted = setadd(exhausted, next_node);
  next_path = this:(verb)(graph, next_node, destination, {@current_path, step_name}, exhausted, shortest_path, depth + 1);
  if (next_path && (!shortest_path || length(next_path) < length(shortest_path)))
    shortest_path = next_path;
  endif
endfor
return shortest_path;
