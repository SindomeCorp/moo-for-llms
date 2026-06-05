" title: private-helper-caller";
" dialect: portable";
" source: original";
" license: MIT";
" topic: permissions";
" provenance: modeled after private $login interception helper guards";
" callable: programmatic";

":add_pending_action(OBJ who, STR verbname, @MIXED arguments) => INT";
"Called only by another verb on this object to record a pending action.";
caller == this || raise(E_PERM);
{who, verbname, @arguments} = args;
if (who in this.pending_players)
  raise(E_INVARG, "Player already has a pending action.");
endif

this.pending_players = {@this.pending_players, who};
this.pending_actions = {@this.pending_actions, {verbname, @arguments}};
return 1;
