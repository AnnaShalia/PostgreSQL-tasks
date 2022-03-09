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

Условие:
Создать скрипт:  <your_lastname>_sp_task5.sql
Имя процедуры - <your_lastname>.<procedure_name>_task5
Имя триггера - <your_lastname>_<trigger_name>_task5
*/

CREATE OR REPLACE FUNCTION shalia.update_sales_task5()
RETURNS trigger
LANGUAGE PLPGSQL
AS $$
BEGIN  
IF TG_OP = 'DELETE' THEN
	IF OLD.salesorderid NOT IN (
		SELECT salesorderid from shalia.salesorderdetail)
    THEN
        RAISE NOTICE '%', tabname;
        --DELETE FROM shalia.salesorderheader 
        --WHERE salesorderid = OLD.salesorderid;
    END IF;
ELSEIF TG_OP = 'UPDATE' THEN
	UPDATE shalia.salesorderheader
	SET totaldue = totaldue - OLD.linetotal + NEW.linetotal
	WHERE salesorderid = OLD.salesorderid;
ELSEIF TG_OP = 'INSERT' THEN
IF NEW.customerid IS NULL THEN
	RAISE EXCEPTION 'Sorry but customer id cannot be null.';
ELSE
    INSERT INTO shalia.salesorderheader(salesorderid, orderdate, customerid, salespersonid, creditcardid, totaldue)
    VALUES (NEW.salesorderid, NEW.modifieddate, NEW.customerid, NEW.salespersonid, NEW.creditcardid, NEW.linetotal)
    ON CONFLICT(salesorderid)
    DO UPDATE SET totaldue = NEW.linetotal + (
        SELECT totaldue FROM shalia.salesorderheader
        WHERE salesorderid = NEW.salesorderid);
END IF;
END IF;
RETURN NULL;  
/*EXCEPTION 
    WHEN OTHERS THEN
        RAISE INFO 'There was an issue with updating salesorderheader table due to the following error: %.',SQLERRM;
        RAISE INFO 'Error State: %', SQLSTATE;
		RETURN NULL;*/
END$$;

CREATE TRIGGER update_sales_trigger_task5
AFTER UPDATE OR INSERT OR DELETE ON shalia.salesorderdetail
FOR EACH ROW
EXECUTE FUNCTION shalia.update_sales_task5();

--testing 
--created tables
SELECT * FROM shalia.salesorderdetail LIMIT 100 WHERE salesorderid = and salesorderdetailid = 111
SELECT * FROM shalia.salesorderheader WHERE salesorderid = 255667 

UPDATE shalia.salesorderdetail
SET linetotal = 111
WHERE salesorderid = 43670 and salesorderdetailid = 111;


INSERT INTO shalia.salesorderdetail
VALUES(255145, 1123, 'test', 3, 12, 1, 6, 0, 23, 'b307c96d-d9e6-403b-8470-2cc176c41283' , '2011-05-31 00:00:00' )

SELECT * FROM shalia.salesorderdetail
WHERE salesorderid = 255145



--creating tables
drop table if exists shalia.salesorderheader;
create table shalia.salesorderheader (like sales.salesorderheader including all);

insert into shalia.salesorderheader
select * 
from sales.salesorderheader;
 
drop table if exists shalia.salesorderdetail;
create table shalia.salesorderdetail (like sales.salesorderdetail including all);
 
insert into shalia.salesorderdetail
select * 
from sales.salesorderdetail;
 
alter table shalia.salesorderdetail
add column customerid int, 
add column salespersonid int,
add column creditcardid int;
 
alter table shalia.salesorderheader
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

