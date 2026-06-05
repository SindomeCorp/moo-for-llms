" title: object-isa-builtin-wrapper";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: objects";
"callable: programmatic";
" provenance: adapted from $object_utils:isa";
" dialect_reason: uses ToastStunt isa() builtin";

":isa(x,y) == is x a y / is obj a $player";
":isa(x,y) == valid(x) && (y==x || y in :ancestors(x))";
return isa(@args);
