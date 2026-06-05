"title: utility-object-utils-all-contents";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:all_contents with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ container";
"returns: LIST";
"notes: Shows recursive object containment traversal.";

":all_contents(OBJ container) => LIST";
"Called by inventory helpers to list nested contents at any depth.";
{container} = args;
results = {};
for item in (container.contents)
  results = {@results, item, @$object_utils:all_contents(item)};
endfor
return results;
