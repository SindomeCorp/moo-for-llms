"title: programmatic-doc-comment-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verb-doc-comments";
"callable: fragment";
"notes: Preserved guidance comments for training data about top comments on programmatic verbs.";

":format_status(OBJ who, LIST stats, ?STR filter) => STR";
"Called by status display verbs to build one line of status text for `who`.";
" Programmatic verbs should start with a signature comment and a usage comment.";
" Optional arguments use ? before the type in the signature and a default in scatter assignment.";
return "Document programmatic call shape before the verb body.";
