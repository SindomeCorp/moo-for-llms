" title: map-print";
" dialect: toaststunt";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: maps";
"callable: programmatic";
" provenance: adapted from $map_utils:map_print";
" dialect_reason: uses ToastStunt MAP, WAIF, ANON, and BOOL datatype constants, map literals, map iteration, and yin()";

":map_print(MAP m, ?depth = 0) => LIST";
"return a list of strings representing the contents of a map that can be";
"printed using player:tell_lines";
{m, ?depth = 0} = args;
if (typeof(m) != MAP)
  raise(E_ARGS, "expected map but got ", typeof(m));
endif
var_vals = [STR -> "STR", INT -> "INT", FLOAT -> "FLOAT", ERR -> "ERR", MAP -> "MAP", LIST -> "LIST", WAIF -> "WAIF", ANON -> "ANON", BOOL -> "BOOL", OBJ -> "OBJ"];
lines = {};
for value, key in (m)
  yin(0);
  string = tostr($string_utils:space(depth), var_vals[typeof(value)], " ", key, ": ");
  if (typeof(value) == MAP)
    if (!length(value))
      lines = {@lines, string, tostr($string_utils:space(depth + 1), "[]")};
    else
      lines = {@lines, string, @this:map_print(value, depth + 1)};
    endif
  elseif (typeof(value) == LIST)
    lines = {@lines, string};
    lines = {@lines, tostr($string_utils:space(depth + 1), toliteral(value))};
  else
    lines = {@lines, string};
    lines = {@lines, tostr($string_utils:space(depth + 1), toliteral(value))};
  endif
endfor
return lines;
