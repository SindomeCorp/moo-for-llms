"title: utility-list-utils-append";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:append with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST ...";
"returns: LIST";
"notes: Shows flattening variadic list arguments with splice syntax.";

":append(LIST ...) => LIST";
"Return a single list containing the elements of each list argument.";
result = {};
for values in (args)
  result = {@result, @values};
endfor
return result;
