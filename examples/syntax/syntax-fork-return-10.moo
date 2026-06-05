"title: syntax-fork-return-10";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":fork_return_10(@MIXED values) => MIXED";
"called by syntax tests to demonstrate fork block syntax.";
{delay} = args;
fork (delay)
  this:after_delay();
endfork
return 1;
