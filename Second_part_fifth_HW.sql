-- Задание №5
WITH RECURSIVE fib(val1, val2, step) AS (
    values (1, 1, 1)
      UNION ALL
    select val2, val1 + val2, step + 1 FROM fib
    where step < 20
)
SELECT array(SELECT val1 FROM fib);
-- Задание №4
WITH RECURSIVE s5(cur, sum51) AS (
	values ((select min(t.idx) from t), (select sum(i) from t where idx between (select min(t.idx) from t) and (select min(t.idx) from t)+4))
		UNION ALL
	select cur+1, (select sum(i) from t where idx between (cur+1) and (cur+5)) from s5
	where cur < (select max(t.idx) from t)
)
SELECT max(sum51) from s5; 			