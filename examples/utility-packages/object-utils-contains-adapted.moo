"title: utility-object-utils-contains";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:contains with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ container, OBJ object";
"returns: INT";
"notes: Shows walking an object's location chain to test containment.";

":contains(OBJ container, OBJ object) => INT";
"Return true when object is inside container at any depth in the location hierarchy.";
{container, object} = args;
while (valid(object))
  object = object.location;
  if (object == container)
    return valid(container);
  endif
endwhile
return 0;
