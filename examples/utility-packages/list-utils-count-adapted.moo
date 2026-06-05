"title: utility-list-utils-count";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:count with permission from Sindome (www.sindome.org); VMS metadata removed, short utility refs expanded, and assignment-inside-condition avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MIXED needle, LIST values";
"returns: INT";
"notes: Shows a simple occurrence count without assigning inside a loop condition.";

":count(MIXED needle, LIST values) => INT";
"Return the number of times needle appears in values.";
{needle, values} = args;
count = 0;
for value in (values)
  if (value == needle)
    count = count + 1;
  endif
endfor
return count;
