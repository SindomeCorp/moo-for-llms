"title: utility-expanded-code-grep-lines-04";
"dialect: portable";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: LIST lines, STR needle";
"returns: LIST";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":grep_lines_4(LIST lines, STR needle) => LIST";
"Called by utility package examples to demonstrate a focused helper pattern.";
{lines, needle} = args;
result = {};
for line in (lines)
  if (index(line, needle))
    result = {@result, line};
  endif
endfor
return result;
