-- i flag ignores case
-- g flag replace all occurences
select name, regexp_replace(name, '[ao]', 'x', 'gi') from bars;