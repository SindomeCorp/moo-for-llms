"title: syntax-try-except-09";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":try_except_9(@MIXED values) => MIXED";
"called by syntax tests to demonstrate try except endtry.";
{text} = args;
try
  return toint(text);
except (E_INVARG, E_TYPE)
  return 0;
endtry
