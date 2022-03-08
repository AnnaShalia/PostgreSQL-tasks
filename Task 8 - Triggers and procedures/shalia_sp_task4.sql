/* Задание 4 (20 балов)
Пример: В конце отчетного года руководство решило наградить трех лучших сотрудников.
Задача: Создать пользовательскую функцию для определения лучших сотрудников продавшего товаров на большую сумму за отчетный период.
Учитываются только оффлайн заказы.
Условие:
Создать скрипт:  <your_lastname>_sp_task4.sql
Имя процедуры - <your_lastname>.<procedure_name>_task4
Используйте таблицы sales.salesorderheader, person.person
Параметры:
<inp_1> – date;
<inp_2> – date;
Возврат функции:
employeeid(salespesonid, businessentityid) – int;
firstname – nvarchar(50);
lastname – nvarchar(50);
rank – int.
*/

CREATE OR REPLACE FUNCTION shalia.get_best_emp_task4(start_date date, end_date date)
RETURNS TABLE (employeeid int,
               firstname varchar(50),
               lastname varchar(50),
               rank int)
LANGUAGE PLPGSQL
AS $$
BEGIN
RETURN QUERY
    WITH employees AS (
        SELECT s.salespersonid, p.firstname, p.lastname, SUM(s.subtotal) subtotal
          FROM sales.salesorderheader s
    INNER JOIN person.person p
            ON s.salespersonid = p.businessentityid
         WHERE s.onlineorderflag = false 
           AND s.orderdate BETWEEN start_date AND end_date
      GROUP BY s.salespersonid, p.firstname, p.lastname
	), 
    ranked_employees AS (
        SELECT e.salespersonid employeeid, e.firstname::varchar(50), e.lastname::varchar(50), 
			   RANK() OVER(ORDER BY e.subtotal DESC)::int rank
          FROM employees e
	)	
    SELECT * 
      FROM ranked_employees re					
     WHERE re.rank BETWEEN 1 AND 3;
END$$;

--test function
SELECT * FROM shalia.get_best_emp_task4('2008-01-31', '2013-01-31')