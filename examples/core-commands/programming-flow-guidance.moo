"title: programming-flow-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: core-commands";
"callable: fragment";
"notes: Documents command/core distinction as preserved MOO string comments; executable body returns a guidance string.";

" .program is a server-level programming command, not a MOO statement.";
" @program and @list are common LambdaCore-style command verbs, not language syntax.";
" Do not put @program inside stored verb source.";
" Do not present set_verb_code(...) as the normal editing workflow.";
return "Use programming commands outside verb source.";
