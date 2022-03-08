/* 1. Задание 1
Задача: Зная электронную почту сотрудника нужно получить его и имя и фамилию, 
а также его возраст. Условие:
Создать скрипт:  <your_lastname>_sp_task1.sql
Имя процедуры - <your_lastname>.<procedure_name>_task1
Используйте таблицы person.emailaddress, person.person, person.employee
Параметры:
<inp> – character varying(100).
Возврат функции:
<return> – varchar.
Пример вывода: “<firstname> <lastname> - <age>”*/


CREATE OR REPLACE FUNCTION shalia.get_emp_details_task1(email varchar(50))
RETURNS varchar 
LANGUAGE PLPGSQL
AS $$
DECLARE 
    res varchar;
BEGIN
    SELECT pp.firstname || ' ' || pp.lastname || ' - ' || 
      DATE_PART('year', AGE(CURRENT_DATE, e.birthdate)) || ' years old.' INTO res
      FROM person.person pp
      JOIN person.emailaddress pe
        ON pp.businessentityid = pe.businessentityid
      JOIN humanresources.employee e
        ON e.businessentityid = pp.businessentityid
     WHERE pe.emailaddress = email;
RETURN res;
END;$$ 


--test function
SELECT shalia.get_emp_details_task1('gail0@adventure-works.com')