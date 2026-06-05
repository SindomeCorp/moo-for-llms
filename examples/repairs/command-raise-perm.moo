" title: command-raise-perm";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" setup: @verb object:@rename any none none";
" callable: command";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (player != this.owner)";
"   raise(E_PERM);";
" endif";
" fixed:";
":@rename(STR new_name) => none";
"Called by a player command to rename an object they own.";
if (player != this.owner)
  player:tell("Only the owner may rename this.");
  return;
endif

if (!dobjstr)
  player:tell("Usage: @rename <new name>");
  return;
endif

this.name = dobjstr;
player:tell("Name set to ", this.name, ".");
