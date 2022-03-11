/*Задание 2 (20 балов)
Пример: Есть торговая точка которая сотрудничает с поставщиками 
и имеет собственные цеха. В некоторых случаях руководство может как 
отказаться от собственного производства и заказывать у поставщиков так и 
начать свое производство -  отказаться от поставщиков.
Выполнить: (В вашей собственной схеме нужно создать новую таблицу.)
drop table if exists <your_lastname>.product;
create table <your_lastname>.product as
select *
  from production.product;
Задача: Создать хранимую процедуру для обновления столбца make_flag в 
таблице <your_lastname>.product, по столбцу name. 
Замечание: Если для заданного продукта значение флага совпадает вывести 
на экран  замечание “<YOUR_COMMENT_1>” и если такого продукта нет в 
таблице вывести “<YOUR_COMMENT_2>”.
Условие:
Создать скрипт:  <your_lastname>_sp_task2.sql
Имя процедуры - <your_lastname>.<procedure_name>_task2
Параметры:
<inp_1> - character varying;
<inp_2> - boolean (true or false).*/

CREATE OR REPLACE PROCEDURE shalia.update_makeflag_task2(product_name varchar, new_flag boolean)
LANGUAGE PLPGSQL
AS $$
BEGIN
IF product_name NOT IN (
    SELECT name 
      FROM shalia.product)
THEN 
    RAISE NOTICE 'The product name "%" wasn''t found in the shalia.product table.',
           product_name; 
ELSEIF new_flag = (
    SELECT makeflag 
      FROM shalia.product 
     WHERE name = product_name)
THEN 
    RAISE NOTICE 'The makeflag for "%" product is already set to %.',
           product_name, new_flag;
ELSE
    UPDATE shalia.product 
       SET makeflag = new_flag 
     WHERE name = product_name;
END IF;
END$$;

--test procedure 
CALL shalia.update_makeflag_task2('Bearing Ball', true)
CALL shalia.update_makeflag_task2('Bearing11 Ball', false)

SELECT * 
  FROM shalia.product 
 WHERE name = 'Bearing Ball'
