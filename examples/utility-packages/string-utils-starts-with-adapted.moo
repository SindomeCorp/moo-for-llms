"title: utility-string-utils-starts-with";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:starts_with with permission from Sindome (www.sindome.org); VMS metadata removed and ToastStunt call_function() avoided for portability.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR text, STR prefix, ?INT case_matters";
"returns: INT";
"notes: Shows a small utility wrapper around index() with an optional case-sensitivity flag.";

":starts_with(STR text, STR prefix, ?INT case_matters) => INT";
"Return 1 when text starts with prefix; case only matters when case_matters is true.";
{text, prefix, ?case_matters = 0} = args;
return index(text, prefix, case_matters) == 1;
