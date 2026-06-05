"title: utility-string-utils-trim";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:trim with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR string, ?STR space";
"returns: STR";
"notes: Shows optional argument destructuring and portable string trimming with match().";

":trim(STR string, ?STR space) => STR";
"Remove leading and trailing copies of space, which defaults to a single space.";
{string, ?space = " "} = args;
match_range = match(string, tostr("[^", space, "]%(.*[^", space, "]%)?%|$"));
return string[match_range[1]..match_range[2]];
