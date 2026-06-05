"title: syntax-range-forward-03";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":range_forward_3(@MIXED values) => MIXED";
"called by syntax tests to build a numeric range list.";
result = {};
for index in [1..5]
  result = {@result, index};
endfor
return result;
