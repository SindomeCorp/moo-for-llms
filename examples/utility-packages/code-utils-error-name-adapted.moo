"title: utility-code-utils-error-name";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:error_name with permission from Sindome (www.sindome.org); VMS metadata and unreachable historical code removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: ERR error";
"returns: STR";
"notes: Shows converting an error value into its literal error-name string.";

":error_name(ERR error) => STR";
"Return the literal name of an error value, such as E_INVARG.";
{error} = args;
return toliteral(error);
