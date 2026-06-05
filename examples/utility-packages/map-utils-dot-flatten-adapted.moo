"title: utility-map-utils-dot-flatten";
"dialect: core-specific";
"dialect_reason: Uses Sindome-specific $map_utils conventions plus ToastStunt MAP type, mapkeys(), and map indexing.";
"source: approved-generic-sindome";
"provenance: Adapted from $map_utils:dot_flatten with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MAP data";
"returns: LIST";
"notes: Shows flattening nested map keys into dot-delimited key paths.";

":dot_flatten(MAP data) => LIST";
"Return dotted key paths for every key in data, including nested MAP values.";
{data} = args;
results = {};
queue = {{"", data}};
while (queue)
  current = queue[1];
  queue = listdelete(queue, 1);
  for key in (mapkeys(current[2]))
    $command_utils:suspend_if_needed(0);
    path = current[1] ? tostr(current[1], ".", key) | tostr(key);
    value = current[2][key];
    queue = typeof(value) == MAP ? {@queue, {path, value}} | queue;
    results = {@results, path};
  endfor
endwhile
return results;
