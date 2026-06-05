"title: repair-assignment-condition-03";
"dialect: portable";
"source: original";
"license: MIT";
"topic: repairs";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Contrastive repair example with bad pattern documented as string comments.";

"bad: if (position = needle in values)";
"fixed: assign before the conditional.";
{needle, values} = args;
position = needle in values;
if (position)
  return values[position];
endif
return 0;
