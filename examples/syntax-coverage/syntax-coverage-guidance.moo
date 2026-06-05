"title: syntax-coverage-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax-coverage";
"callable: fragment";
"notes: Preserved guidance comments for training data about valid syntax examples.";

" Syntax coverage examples should compile as valid MOO source.";
" Invalid examples belong in contrastive repair rows with a corrected version.";
" Durable MOO comments are quoted string literal statements ending in semicolons.";
" ToastStunt syntax such as maps and type constants must be labeled by dialect.";
return "Prefer valid narrow examples for syntax coverage.";
