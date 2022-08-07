-- Задание №1
CREATE OR REPLACE FUNCTION f(ru_mark integer)
           RETURNS text
		   LANGUAGE plpgsql
		   AS
   $$
        DECLARE
           mark text;
        BEGIN 
        IF ru_mark = 5 THEN
           mark := 'A';
		END IF;
		IF ru_mark = 4 THEN
           mark := 'B'; 
		END IF;
		IF ru_mark = 3 THEN
           mark := 'C'; 
		END IF;
		IF ru_mark = 2 THEN
           mark := 'D'; 
		END IF;
		IF ru_mark = 1 THEN
           mark := 'F';
		END IF;
        RETURN mark;
        END;
   $$;
   
-- Задание №2
create table students(student_id integer, course_id integer, grade integer, primary key (student_id, course_id));
create or replace procedure grade_(student_id_0 integer, corse_id_0 integer, grade_0 integer)
LANGUAGE plpgsql
as 
$$
begin
insert into students values (student_id_0, course_id_0, grade_0)
on conflict (student_id, course_id) do update set grade = grade_0;
end;
$$;

-- Задание №3
create or replace function prime(n integer)
returns integer array
LANGUAGE plpgsql
as
$$
declare 
prime_ integer array;
begin 
if n > 1000 then 
n := 1000;
end if;
prime_ = (select array( WITH x AS (
  SELECT * FROM generate_series( 2, n) x
) SELECT x.x
FROM x
WHERE NOT EXISTS (
  SELECT 1 FROM x y
  WHERE x.x > y.x AND x.x % y.x = 0
)) as prime_);
RETURN prime_;
end;
$$;
