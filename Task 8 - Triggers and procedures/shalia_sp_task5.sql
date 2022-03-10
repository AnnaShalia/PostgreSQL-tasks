/* Задание 5 (30 балов)
Пример: Покупатель связался с менеджером чтобы оформить заказ.
Задача: Создать функцию триггера и триггер для оформления заказа и добавления его в 
таблицы <your_lastname>.salesorderheader и <your_lastname>.salesorderdetail 
(триггер для этой таблицы с действиями(update,delete,insert)).
Менеджер добавляет товар в таблицу <your_lastname>.salesorderdetail после добавления 
каждого нового товара или удалении из таблицы из этой таблицы, общая информация должна вставляться,
удаляться или обновляться (обновляется только столбец totaldue = sum(totaline from <your_lastname>.salesorderdetail)) 
в таблице <your_lastname>.salesorderheader.
Если значение столбца totaline изменилось или строка была удалена нужно  добавить или 
отнять это значение в totaldue. При удаления всех данных для одного заказа 
<your_lastname>.salesorderdetail. нужно удалить все данные в таблице <your_lastname>.salesorderheader 
для этого заказа.
Выполнить: (В вашей собственной схеме нужно создать новые таблицы.)
drop table if exists <your_lastname>.salesorderheader;
create table <your_lastname>.salesorderheader (like sales.salesorderheader including all);
 
insert into <your_lastname>.salesorderheader
select * 
from sales.salesorderheader;
 
drop table if exists <your_lastname>.salesorderdetail;
create table <your_lastname>.salesorderdetail (like sales.salesorderdetail including all);
 
insert into <your_lastname>.salesorderdetail
select * 
from sales.salesorderdetail;
 
alter table <your_lastname>.salesorderdetail
add column customerid int, 
add column salespersonid int,
add column creditcardid int;
 
alter table <your_lastname>.salesorderheader
drop column revisionnumber,
drop column duedate,
drop column shipdate,
drop column salesordernumber,
drop column purchaseordernumber,
drop column accountnumber,
drop column territoryid,
drop column billtoaddressid,
drop column shipmethodid,
drop column creditcardapprovalcode,
drop column currencyrateid,
drop column subtotal,
drop column taxamt,
drop column freight,
drop column comment,
drop column rowguid,
drop column modifieddate,
drop column shiptoaddressid;

Условие:
Создать скрипт:  <your_lastname>_sp_task5.sql
Имя процедуры - <your_lastname>.<procedure_name>_task5
Имя триггера - <your_lastname>_<trigger_name>_task5
*/

--trigger function
CREATE OR REPLACE FUNCTION shalia.update_sales_task5()
RETURNS trigger
LANGUAGE PLPGSQL
AS $$
BEGIN  
IF TG_OP = 'DELETE' THEN
    IF EXISTS (
       SELECT * 
         FROM shalia.salesorderdetail 
        WHERE salesorderid = OLD.salesorderid)
    THEN 
       UPDATE shalia.salesorderheader
          SET totaldue = totaldue - OLD.linetotal
        WHERE salesorderid = OLD.salesorderid;
    ELSE 
       DELETE
         FROM shalia.salesorderheader 
        WHERE salesorderid = OLD.salesorderid;
    END IF;
ELSEIF TG_OP = 'UPDATE' THEN
    UPDATE shalia.salesorderheader
       SET totaldue = totaldue - OLD.linetotal + NEW.linetotal
     WHERE salesorderid = OLD.salesorderid;
ELSEIF TG_OP = 'INSERT' THEN
    INSERT INTO shalia.salesorderheader(salesorderid, orderdate, customerid, salespersonid, creditcardid, totaldue)
    VALUES (NEW.salesorderid, NEW.modifieddate, NEW.customerid, NEW.salespersonid, NEW.creditcardid, NEW.linetotal)
        ON CONFLICT(salesorderid)
 DO UPDATE 
       SET totaldue = NEW.linetotal + (
    SELECT totaldue 
      FROM shalia.salesorderheader
     WHERE salesorderid = NEW.salesorderid);
END IF;
RETURN NULL;
EXCEPTION 
    WHEN OTHERS THEN
        RAISE INFO 'There was an issue with updating salesorderheader table due to the following error: %.',SQLERRM;
        RAISE INFO 'Error State: %', SQLSTATE;
    RETURN NULL;
END$$;

--trigger
CREATE TRIGGER update_sales_trigger_task5
    AFTER DELETE OR UPDATE OR INSERT ON shalia.salesorderdetail
    FOR EACH ROW
    EXECUTE FUNCTION shalia.update_sales_task5();

--testing of updating salesorderdetail table
SELECT * 
  FROM shalia.salesorderdetail 
 WHERE salesorderid = 43670;
 
SELECT * 
  FROM shalia.salesorderheader 
 WHERE salesorderid = 43670;

UPDATE shalia.salesorderdetail
   SET linetotal = 115
 WHERE salesorderid = 43670 AND salesorderdetailid = 111;

--testing of inserting the new item to them salesorderdetail
--if the order doesn't exist in salesorderheader table:
INSERT INTO shalia.salesorderdetail
VALUES(25514588, 1123, 'test', 3, 12, 1, 6, 0, 23, 'b308c96d-d9e6-403b-8470-2cc176c41283' , 
     '2011-05-31 00:00:00', 112);

SELECT * 
  FROM shalia.salesorderheader 
 WHERE salesorderid = 25514588;

--if the order exists in salesorderheader table:
SELECT * 
  FROM shalia.salesorderheader 
 WHERE salesorderid = 43671;

INSERT INTO shalia.salesorderdetail
VALUES(43671, 1123, 'test', 3, 12, 1, 6, 0, 1, 'b408c96d-d9e6-403b-8470-2cc176c41283' , 
     '2011-05-31 00:00:00', 112);

--testing deleting one of the order items (not the last one) from orderdetails table
SELECT * 
  FROM shalia.salesorderheader 
 WHERE salesorderid = 43679;

SELECT * 
  FROM shalia.salesorderdetail 
 WHERE salesorderid = 43679;
 
DELETE 
  FROM shalia.salesorderdetail
 WHERE salesorderid = 43679 AND salesorderdetailid = 188;

--testing deleting the last order item from orderdetails table
SELECT * 
  FROM shalia.salesorderheader 
 WHERE salesorderid = 47051;

SELECT * 
  FROM shalia.salesorderdetail 
 WHERE salesorderid = 47051;

DELETE 
  FROM shalia.salesorderdetail
 WHERE salesorderid = 47051;
 
