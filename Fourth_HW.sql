-- Задача №1
select num from T where (num % 2 = 0) and ((num % 3 = 0) or (num % 7 = 0));
-- Задача №4
select 5050 - SUM(num) from T;
-- Задача №3
select set, ceiling(exp(sum(ln(num)))) from M group by set;
-- Задача №5
select s1 
from T1
left join T2 
  on s1 = s2
where s2 is null

union all

select s2
from T1
right join T2 
  on s1 = s2
where s1 is null;
-- Задача №6
select DeptID, SUM(Salary) from Employee group by DeptID HAVING COUNT(DeptID) > 1;

