"title: utility-expanded-time-seconds-label-05";
"dialect: portable";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: INT seconds";
"returns: STR";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":seconds_label_5(INT seconds) => STR";
"Called by utility package examples to demonstrate a focused helper pattern.";
{seconds} = args;
if (seconds < 60)
  return tostr(seconds, " seconds");
endif
minutes = seconds / 60;
return tostr(minutes, " minutes");
