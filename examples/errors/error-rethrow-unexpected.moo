"title: error-rethrow-unexpected";
"dialect: portable";
"source: original";
"license: MIT";
"topic: errors";
"callable: programmatic";
"args: OBJ object";
"returns: ANY";
"notes: Shows catching one expected error while letting unexpected failures propagate.";

":read_optional_label(OBJ object) => ANY";
"Called by display helpers where a missing label has a default but permission errors should surface.";
{object} = args;
return `object.label ! E_PROPNF => "untitled"';
