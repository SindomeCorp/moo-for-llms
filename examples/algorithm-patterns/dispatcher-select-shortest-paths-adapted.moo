"title: algorithm-dispatcher-select-shortest-paths";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $dispatcher:dispatch_allies with permission from Sindome (www.sindome.org); action side effects, broadcasts, short refs, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST candidates, INT max_count";
"returns: LIST";
"notes: Shows repeatedly selecting the available candidate with the shortest path.";

":select_shortest_path_candidates(LIST candidates, INT max_count) => LIST";
"Called by dispatcher-style helpers to choose the closest candidates first.";
{candidates, max_count} = args;
selected = {};
while (candidates && length(selected) < max_count)
  best_index = 1;
  best_length = length(candidates[1]);
  if (length(candidates) > 1)
    for index in [2..length(candidates)]
      if (length(candidates[index]) < best_length)
        best_index = index;
        best_length = length(candidates[index]);
      endif
    endfor
  endif
  selected = {@selected, candidates[best_index]};
  candidates[best_index..best_index] = {};
endwhile
return selected;
