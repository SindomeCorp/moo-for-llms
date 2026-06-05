"title: lambdamoo-builtins-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: lambdamoo-builtins";
"callable: fragment";
"notes: Preserved guidance comments for training data about LambdaMOO builtin portability.";

" Portable examples may use stock LambdaMOO builtins and common core utility verbs.";
" Core utility verbs such as $list_utils:slice are not server builtins, but they are common on LambdaCore-style cores.";
" Do not classify code as ToastStunt-specific only because ToastStunt also provides a faster builtin for the same operation.";
" Label portability by the code actually used.";
return "Separate server builtins from core utility verbs.";
