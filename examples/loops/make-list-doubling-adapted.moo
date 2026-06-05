"title: make-list-doubling-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:make with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: loops";
"callable: programmatic";
"args: INT count, ?MIXED value";
"returns: LIST|ERR";
"notes: Shows a compact while loop that builds repeated elements by doubling a working list.";

":make_repeated(INT count, ?MIXED value) => LIST|ERR";
"Called by list utilities to create count copies of value.";
{count, ?value = 0} = args;
if (count < 0)
  return E_INVARG;
endif
result = {};
build = {value};
while (1)
  if (count % 2)
    result = {@result, @build};
  endif
  count = count / 2;
  if (count)
    build = {@build, @build};
  else
    return result;
  endif
endwhile
