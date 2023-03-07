create or replace view Beer_and_Brewer as
select be.name as beer, br.name as brewer
from beers be
join brewers br on (be.brewer = br.id)
;

-- Q1 What beers are made by Toohey's?

select *
from beer_and_brewer
where brewer = 'Toohey''s';

-- Q3 Find the brewers whose beers John likes.

select br.name
from drinkers d
join likes l on (d.id = l.drinker)
join beers be on (be.id = l.beer)
join brewers br on (be.brewer = br.id)
where d.name = 'John';

-- Q4 How many different beers are there?

select count(*) as "#beers"
from beers;

-- Q6 Find pairs of beers by the same manufacturer

select b1.beer as beer1, b2.beer as beer2
from beer_and_brewer b1
join beer_and_brewer b2 on (b1.brewer = b2.brewer)
where b1.beer < b2.beer;

-- Q7 How many beers does each brewer make?

select brewer, count(*)
from beer_and_brewer
group by brewer;