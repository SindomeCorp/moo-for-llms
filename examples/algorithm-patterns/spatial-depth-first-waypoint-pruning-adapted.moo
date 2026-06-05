"title: algorithm-spatial-depth-first-waypoint-pruning";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $room:best_waypoint_path with permission from Sindome (www.sindome.org); room-specific waypoint objects, short refs, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST waypoint_graph, MIXED current, MIXED destination, ?LIST current_path, ?LIST exhausted, ?LIST shortest_path";
"returns: LIST";
"notes: Shows depth-first waypoint search with branch pruning when the current stack is already worse than the best known path.";

":best_waypoint_path(LIST waypoint_graph, MIXED current, MIXED destination, ?LIST current_path, ?LIST exhausted, ?LIST shortest_path) => LIST";
"Called by routing helpers to find the shortest path through waypoint nodes.";
{waypoint_graph, current, destination, ?current_path = {}, ?exhausted = {}, ?shortest_path = {}} = args;
if (shortest_path && length(current_path) > length(shortest_path))
  return shortest_path;
elseif (current == destination)
  if (!shortest_path || length(current_path) < length(shortest_path))
    return current_path;
  endif
  return shortest_path;
endif
row = $list_utils:assoc(current, waypoint_graph);
if (!row)
  return shortest_path;
endif
for point in (row[2])
  {next_node, step_name} = point;
  if (next_node in exhausted)
    continue;
  elseif (length(current_path) > 14)
    continue;
  endif
  exhausted = setadd(exhausted, next_node);
  next_path = this:(verb)(waypoint_graph, next_node, destination, {@current_path, step_name}, exhausted, shortest_path);
  $command_utils:suspend_if_needed(0);
  if (next_path && (!shortest_path || length(next_path) < length(shortest_path)))
    shortest_path = next_path;
  endif
endfor
return shortest_path;
