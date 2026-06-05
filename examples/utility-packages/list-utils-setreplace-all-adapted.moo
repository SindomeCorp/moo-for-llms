"title: utility-list-utils-setreplace-all";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:setreplace_all with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-inside-condition avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values, MIXED search, MIXED replacement";
"returns: LIST";
"notes: Shows replacing every occurrence of a value, including splice replacement when replacement is a list.";

":setreplace_all(LIST values, MIXED search, MIXED replacement) => LIST";
"Return values with every occurrence of search replaced by replacement.";
{values, search, replacement} = args;
position = search in values;
while (position)
  if (typeof(replacement) == LIST)
    values[position..position] = {@replacement};
  else
    values[position..position] = {replacement};
  endif
  position = search in values;
endwhile
return values;
