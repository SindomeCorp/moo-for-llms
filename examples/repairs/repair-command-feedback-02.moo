"title: repair-command-feedback-02";
"dialect: portable";
"source: original";
"license: MIT";
"topic: repairs";
"setup: @verb object:repair any any any";
"callable: command";
"args: varies";
"returns: varies";
"notes: Contrastive repair example with bad pattern documented as string comments.";

"bad: raise(E_INVARG) for a normal command failure.";
"fixed: tell the player and return.";
if (!valid(dobj))
  player:tell("Choose a valid target.");
  return;
endif
player:tell("Target: ", dobj.name);
