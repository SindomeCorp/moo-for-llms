"title: algorithm-spatial-neighbor-coordinate-scan";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $spatial:return_spatical_neighbors with permission from Sindome (www.sindome.org); matrix object lookup, short refs, raw object defaults, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST coords, INT radius";
"returns: LIST";
"notes: Shows scanning coordinate offsets around a point and skipping the origin.";

":neighbor_offsets_3d(LIST coords, INT radius) => LIST";
"Called by spatial helpers to produce nearby coordinate offsets before resolving them to rooms.";
{coords, radius} = args;
neighbors = {};
for axis in [1..3]
  for offset in [0 - radius..radius]
    if (offset == 0)
      continue;
    endif
    candidate = coords;
    candidate[axis] = coords[axis] + offset;
    neighbors = setadd(neighbors, candidate);
  endfor
endfor
return neighbors;
