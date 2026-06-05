" title: player-wizard-api-check";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (!player.wizard)";
"   raise(E_PERM);";
" endif";
" fixed:";
":admin_rebuild() => INT";
"Called by another verb to rebuild internal state; requires wizard permissions on the caller.";
if (!caller_perms().wizard)
  raise(E_PERM);
endif

this:_rebuild_cache();
return 1;
