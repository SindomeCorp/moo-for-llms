"title: algorithm-string-parallel-substitute";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:substitute with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: STR text, LIST substitutions, ?INT case_matters";
"returns: STR";
"notes: Shows parallel substitution with leftmost match precedence and longer same-position match preference.";

":parallel_substitute(STR text, LIST substitutions, ?INT case_matters) => STR";
"Called by text filters to replace multiple patterns without cascading replacements.";
{text, substitutions, ?case_matters = 0} = args;
remaining = text;
remaining_length = length(remaining);
indices = {};
matches = {};
for substitution in (substitutions)
  position = substitution[1] ? index(remaining, substitution[1], case_matters) | 0;
  if (position)
    key = position - remaining_length;
    insert_at = $list_utils:find_insert(indices, key) - 1;
    while (insert_at && indices[insert_at] == key && length(matches[insert_at][1]) < length(substitution[1]))
      insert_at = insert_at - 1;
    endwhile
    indices = listappend(indices, key, insert_at);
    matches = listappend(matches, substitution, insert_at);
  endif
endfor
result = "";
while (matches)
  $command_utils:suspend_if_needed(0);
  position = remaining_length + indices[1];
  substitution = matches[1];
  indices = listdelete(indices, 1);
  matches = listdelete(matches, 1);
  if (position > 0)
    result = result + remaining[1..position - 1] + substitution[2];
    remaining = remaining[position + length(substitution[1])..remaining_length];
    remaining_length = length(remaining);
  endif
  next = index(remaining, substitution[1], case_matters);
  if (next)
    key = next - remaining_length;
    insert_at = $list_utils:find_insert(indices, key) - 1;
    indices = listappend(indices, key, insert_at);
    matches = listappend(matches, substitution, insert_at);
  endif
endwhile
return result + remaining;
