"title: algorithm-spatial-breadth-first-frontier";
"dialect: portable";
"source: original";
"license: MIT";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST graph, MIXED start, MIXED destination";
"returns: LIST";
"notes: Shows breadth-first search with a FIFO frontier; included as contrast with recursive find_if_near-style DFS.";

":breadth_first_path(LIST graph, MIXED start, MIXED destination) => LIST";
"Called by routing helpers when the first discovered path should be the shortest unweighted path.";
{graph, start, destination} = args;
frontier = {{start, {}}};
visited = {start};
while (frontier)
  $command_utils:suspend_if_needed(0);
  {current, path} = frontier[1];
  if (length(frontier) > 1)
    frontier = frontier[2..$];
  else
    frontier = {};
  endif
  if (current == destination)
    return path;
  endif
  row = $list_utils:assoc(current, graph);
  if (!row)
    continue;
  endif
  for edge in (row[2])
    {next_node, step_name} = edge;
    if (!(next_node in visited))
      visited = setadd(visited, next_node);
      frontier = {@frontier, {next_node, {@path, step_name}}};
    endif
  endfor
endwhile
return {};
