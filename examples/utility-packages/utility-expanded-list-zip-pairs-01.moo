"title: utility-expanded-list-zip-pairs-01";
"dialect: portable";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: LIST left, LIST right";
"returns: LIST";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":zip_pairs_1(LIST left, LIST right) => LIST";
"Called by utility package examples to demonstrate a focused helper pattern.";
{left, right} = args;
count = min(length(left), length(right));
result = {};
for index in [1..count]
  result = {@result, {left[index], right[index]}};
endfor
return result;
