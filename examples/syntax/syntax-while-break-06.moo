"title: syntax-while-break-06";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":while_break_6(@MIXED values) => MIXED";
"called by syntax tests to demonstrate while and break.";
{items, needle} = args;
index = 1;
while (index <= length(items))
  if (items[index] == needle)
    break;
  endif
  index = index + 1;
endwhile
return index <= length(items) ? index | 0;
