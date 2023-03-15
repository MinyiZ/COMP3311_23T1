select bar, beer, price,
    case
        when price < 3 then 'cheap'
        when price > 10 then 'so exxy wow it''s ' || price || ' dollars'
        else 'meh'
    end as msg
from sells;