"title: toaststunt-builtins-guidance";
"dialect: toaststunt";
"dialect_reason: Discusses ToastStunt-only builtins such as MAP helpers and parse_json().";
"source: original";
"license: MIT";
"topic: toaststunt-builtins";
"callable: fragment";
"notes: Preserved guidance comments for training data about ToastStunt-specific builtins.";

" ToastStunt-specific examples should be labeled toaststunt when they call ToastStunt-only builtins.";
" Builtins such as mapkeys, mapvalues, parse_json, curl, new_waif, and descendants create a dialect dependency.";
" Patch-specific builtins such as xml_parse_tree should be labeled patch-specific instead of ToastStunt-specific.";
" Core utility verbs should be distinguished from server builtins with similar names.";
value = typeof([]);
return "Use ToastStunt labels for ToastStunt-only server features.";
