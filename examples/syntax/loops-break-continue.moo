"title: loops-break-continue";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: INT";
"notes: Compile-tested against a live MOO scratch verb.";

items = {1, 2, 3, 4};
total = 0;
for item in (items)
  if (item == 2)
    continue;
  endif
  if (item > 3)
    break;
  endif
  total = total + item;
endfor
index = 1;
while (index <= length(items))
  index = index + 1;
endwhile
return total;
