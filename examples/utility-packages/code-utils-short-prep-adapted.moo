"title: utility-code-utils-short-prep";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:short_prep with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-inside-condition avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR preposition";
"returns: STR";
"notes: Shows normalizing a preposition phrase to the shortest equivalent stored by the utility object.";

":short_prep(STR preposition) => STR";
"Return the shortest preposition equivalent to preposition, or an empty string if none is known.";
{preposition} = args;
if (server_version() != this._version)
  this:_fix_preps();
endif
word = preposition[1..index(preposition + "/", "/") - 1];
position = word in this._other_preps;
if (position)
  return this._short_preps[this._other_preps_n[position]];
elseif (word in this._short_preps)
  return word;
else
  return "";
endif
