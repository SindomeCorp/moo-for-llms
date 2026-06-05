"title: utility-list-utils-make";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:make with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-inside-condition avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT count, ?MIXED value";
"returns: LIST|ERR";
"notes: Shows efficient repeated-list construction with explicit loop-condition updates.";

":make(INT count, ?MIXED value) => LIST|ERR";
"Return a list of count copies of value, or E_INVARG when count is negative.";
{count, ?value = 0} = args;
if (count < 0)
  return E_INVARG;
endif
result = {};
chunk = {value};
while (count)
  if (count % 2)
    result = {@result, @chunk};
  endif
  count = count / 2;
  if (count)
    chunk = {@chunk, @chunk};
  endif
endwhile
return result;
