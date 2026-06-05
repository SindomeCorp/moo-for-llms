"title: algorithm-list-compress-runs";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:compress with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows removing only consecutive duplicate runs while preserving later repeated values.";

":compress_runs(LIST values) => LIST";
"Called by list normalization helpers to collapse adjacent repeated values.";
{values} = args;
if (!values)
  return values;
endif
last = values[1];
result = {last};
if (length(values) > 1)
  for value in (values[2..$])
    if (value != last)
      result = {@result, value};
      last = value;
    endif
  endfor
endif
return result;
