"title: algorithm-selection-notes";
"dialect: portable";
"source: original";
"license: MIT";
"topic: algorithm-patterns";
"callable: fragment";
"notes: Valid MOO string-literal comments summarizing algorithm selection guidance for training data.";

"Use list-based search, grouping, deduplication, and splice algorithms for portable MOO examples.";
"Use ToastStunt-specific labels when an example calls map builtins, uses map literals, or relies on server-only helpers such as sort().";
"Prefer one clear algorithm per example so the training target is not hidden inside presentation or permission code.";
"For long scans, sorts, or recursive traversals, show periodic yielding or explain why the input is bounded.";
"When adapting live utility verbs, remove local history notes and expand short core refs such as $lu or $ou to their corified long names.";
