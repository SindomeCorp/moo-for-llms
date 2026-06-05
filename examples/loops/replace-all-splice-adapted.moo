"title: replace-all-splice-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:setreplace_all with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: loops";
"callable: programmatic";
"args: LIST values, MIXED search, MIXED replacement";
"returns: LIST";
"notes: Shows replacing every matching element, including the case where replacement is itself a list to splice in.";

":replace_all(LIST values, MIXED search, MIXED replacement) => LIST";
"Called by list normalization helpers to replace all matches with a scalar or spliced list.";
{values, search, replacement} = args;
while (index = search in values)
  if (typeof(replacement) == LIST)
    values[index..index] = {@replacement};
  else
    values[index..index] = {replacement};
  endif
endwhile
return values;
