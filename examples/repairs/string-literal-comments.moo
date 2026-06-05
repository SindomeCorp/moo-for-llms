" title: string-literal-comments";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippets are shown in comments; executable body demonstrates preserved MOO string-literal comments";

" bad:";
" // This may be accepted by ToastStunt source input, but it is not parsed as a MOO statement and will be dropped from stored verb code.";
" /* Block comments are not portable stored MOO comments either. */";
" \"This string comment is missing its terminating semicolon\"";
" fixed:";
" This is a proper MOO string-literal comment and remains in stored verb code.";
player:tell("Comment syntax repaired.");
