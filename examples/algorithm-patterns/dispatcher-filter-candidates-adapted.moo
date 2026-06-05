"title: algorithm-dispatcher-filter-candidates";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $dispatcher:available_allies with permission from Sindome (www.sindome.org); faction/NPC/spatial dependencies, broad catch, short refs, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST candidates, MIXED requester, MIXED destination, ?INT limit";
"returns: LIST";
"notes: Shows candidate filtering with skips for self, same location, busy state, missing path, and optional result limit.";

":available_candidates(LIST candidates, MIXED requester, MIXED destination, ?INT limit) => LIST";
"Called by dispatcher-style helpers to find candidates with usable paths.";
{candidates, requester, destination, ?limit = 0} = args;
available = {};
for row in (candidates)
  $command_utils:suspend_if_needed(0);
  {candidate, location, busy, path} = row;
  if (candidate == requester)
    continue;
  elseif (location == destination)
    continue;
  elseif (busy)
    continue;
  elseif (!path)
    continue;
  endif
  available = {@available, {candidate, @path}};
  if (limit && length(available) >= limit)
    return available;
  endif
endfor
return available;
