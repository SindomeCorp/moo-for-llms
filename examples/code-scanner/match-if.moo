" title: match-if";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: code-scanner";
"callable: programmatic";
" provenance: adapted from $code_scanner:match_if";

":match_if(STR line) => bool";
"SINDOME ASCII EATS THE CARAT. IF YOU EDIT THIS VERB YOU NEED TO INCLUDE";
"A CARRAT CHARACTER AT THE START OF THE REGEX STRING";
{line} = args;
return match(line, "^[ ]*if ");
