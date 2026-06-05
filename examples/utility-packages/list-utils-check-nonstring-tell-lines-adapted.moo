"title: utility-list-utils-check-nonstring-tell-lines";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:check_nonstring_tell_lines with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST lines";
"returns: INT";
"notes: Shows wizard-gated diagnostic collection for tell_lines-style output validation.";

":check_nonstring_tell_lines(LIST lines) => INT";
"Record caller stack diagnostics when a wizard-owned helper sees non-string tell_lines input.";
{lines} = args;
if (!caller_perms().wizard)
  return 0;
endif
for line in (lines)
  if (typeof(line) != STR)
    this.nonstring_tell_lines = listappend(this.nonstring_tell_lines, callers());
    return 1;
  endif
endfor
return 0;
