"title: syntax-range-reverse-04";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":range_reverse_4(@MIXED values) => MIXED";
"called by syntax tests to traverse a string backward.";
{text} = args;
result = "";
for index in [length(text)..1]
  result = result + text[index];
endfor
return result;
