"title: toerr-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:toerr with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: errors";
"callable: programmatic";
"args: INT|STR value";
"returns: ERR|INT";
"notes: Shows converting either an error index or an error-name string into an ERR value.";

":toerr(INT|STR value) => ERR|INT";
"Called by code utilities that accept either E_FOO names or numeric error positions.";
{value} = args;
if (typeof(value) != STR)
  index = toint(value) + 1;
  if (index > length(this.error_list))
    return 1;
  endif
elseif (!(index = value in this.error_names || "E_" + value in this.error_names))
  return 1;
endif
return this.error_list[index];
