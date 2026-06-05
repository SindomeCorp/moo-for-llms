" title: fork-guidance";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: fragment";
" notes: bad snippet is shown in comments; executable body is guidance because scheduler APIs vary by core";

" bad:";
" fork (delay)";
"   player:tell(message);";
" endfork";
" fixed:";
" Forks run later; capture needed values before forking and validate objects inside the fork.";
" Prefer a scheduler utility when the target core provides one.";
