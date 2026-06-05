"title: algorithm-list-recursive-flatten";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:flatten with permission from Sindome (www.sindome.org); historical note and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST nested";
"returns: LIST";
"notes: Shows recursive traversal of arbitrarily nested lists.";

":flatten_list(LIST nested) => LIST";
"Called by normalization helpers to turn nested lists into a flat list.";
{nested} = args;
result = {};
for value in (nested)
  if (typeof(value) == LIST)
    result = {@result, @this:flatten_list(value)};
  else
    result = {@result, value};
  endif
endfor
return result;
