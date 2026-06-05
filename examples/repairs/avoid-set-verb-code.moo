" title: avoid-set-verb-code";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected guidance as string-literal comments";

" bad:";
" set_verb_code(object, verbname, lines);";
" fixed:";
" Use .program for server-level verb programming, where appropriate for wizards.";
" Use @program on LambdaCore-style cores when a programmer-facing command verb is available.";
" Use set_verb_code only in examples explicitly about verb mutation APIs.";
