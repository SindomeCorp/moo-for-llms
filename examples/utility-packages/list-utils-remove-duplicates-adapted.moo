"title: utility-list-utils-remove-duplicates";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:remove_duplicates with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows using setadd() to preserve one copy of each value.";

":remove_duplicates(LIST values) => LIST";
"Return values with repeated elements removed.";
{values} = args;
result = {};
for value in (values)
  result = setadd(result, value);
endfor
return result;
