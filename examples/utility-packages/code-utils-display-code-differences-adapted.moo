"title: utility-code-utils-display-code-differences";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:display_code_differences with permission from Sindome (www.sindome.org); ANSI output and source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST old_lines, LIST new_lines, ?INT line_numbers";
"returns: LIST";
"notes: Shows formatting a simple line-oriented code difference without player feedback.";

":display_code_differences(LIST old_lines, LIST new_lines, ?INT line_numbers) => LIST";
"Return display lines showing changed source lines from old_lines to new_lines.";
{old_lines, new_lines, ?line_numbers = 0} = args;
limit = max(length(old_lines), length(new_lines));
output = {};
for index in [1..limit]
  old = `old_lines[index] ! E_RANGE => ""';
  new = `new_lines[index] ! E_RANGE => ""';
  if (old != new)
    prefix = line_numbers ? tostr(index, ": ") | "";
    output = {@output, tostr(prefix, "- ", old), tostr(prefix, "+ ", new)};
  endif
endfor
return output;
