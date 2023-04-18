create table ab (a text, b text);
create table ab3 (a text, b text);
create table ac (a text, c text);
create table abc (a text, b text, c text);

insert into ab values ('a1', 'b1');
insert into ab values ('a2', 'b2');

insert into ab3 values ('a3', 'b3');

insert into ac values ('a1', 'c1');
insert into ac values ('a2', 'c2');

insert into abc values ('a1', 'b1', 'c1');
insert into abc values ('a1', 'b2', 'c2');
insert into abc values ('a2', 'b2', 'c2');

-- example queries
-- select * from ab natural join ac;
-- select * from ab join ac on (ab.a = ac.a);
-- select * from ab join ac on (ab.a < ac.a);
-- select * from ab3 left outer join abc on (ab3.a = abc.a);
-- select * from ab3 right outer join abc on (ab3.a = abc.a);
