" title: owner-check";
" dialect: portable";
" source: original";
" license: MIT";
" topic: permissions";
" provenance: modeled after command owner checks such as $room:@addroomfeature";
" setup: @verb object:@toggle any none none";
" callable: command";

":@toggle(OBJ setting) => none";
"Called by a player command to toggle a setting on an object they own.";
if (player != this.owner)
  player:tell("Only the owner may change this setting.");
  return;
endif

if (!valid(dobj))
  player:tell("Toggle what?");
  return;
endif

if (dobj != this)
  player:tell("That is not controlled by this command.");
  return;
endif

this.enabled = !this.enabled;
player:tell("Enabled: ", this.enabled);
