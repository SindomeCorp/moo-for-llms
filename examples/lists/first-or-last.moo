" title: first-or-last";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $list_utils:first / $list_utils:last";

return verb == "first" ? args[1][1] | args[1][$];
