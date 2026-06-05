"title: cp-none-prep-to";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@route none to any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@route() => none";
"Called by a player command using parser variables; demonstrates argspec none to any.";
if (!valid(iobj))
  player:tell("Route to what?");
  return;
endif
this.route_to = iobj;
player:tell("Route target: ", iobj.name);
