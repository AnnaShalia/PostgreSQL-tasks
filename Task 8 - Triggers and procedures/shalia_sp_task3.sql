/* Задание 3 (20 балов)
Пример: Нужно получить ежедневные, месячные и годовые отчеты о сумме продаж, 
средней сумме продаж, количестве заказов, как был оформлен заказ(онлайн или офлайн) например, за последние 10 лет.
Выполнить: (В вашей собственной схеме нужно создать новые таблицы.)
drop table if exists <your_lastname>.sales_report_total_daily;
create table <your_lastname>.sales_report_total_daily (
    date_report             timestamp with time zone,
    onlineorderflag     boolean,
    sum_total           numeric,
    avg_total           numeric,
    qty_orders          int);
drop table if exists <your_lastname>.sales_report_total_monthly;
create table if not exists <your_lastname>.sales_report_total_monthly (
    date_report            timestamp with time zone,
    onlineorderflag     boolean,
    sum_total           numeric,
    avg_total           numeric,
    qty_orders          int);
drop table if exists <your_lastname>.sales_report_total_yearly;
create table if not exists <your_lastname>.sales_report_total_yearly (
    date_report            timestamp with time zone,
    onlineorderflag     boolean,
    sum_total           numeric,
    avg_total           numeric,
    qty_orders          int);
Задача: Создать хранимую процедуру для получения отчетов, которые записываются в таблицы.
ежедневные -  <your_lastname>.sales_report_total_daily 
месячные -  <your_lastname>.sales_report_total_monthly 
годовые -  <your_lastname>.sales_report_total_yearly
Условие:
Создать скрипт:  <your_lastname>_sp_task3.sql
Имя процедуры - <your_lastname>.<procedure_name>_task3
Используйте таблицу sales.salesorderheader
Параметры:
<inp> – int.*/

CREATE OR REPLACE PROCEDURE shalia.generate_reports_task3(period_years int)
LANGUAGE PLPGSQL
AS $$
BEGIN
--cleaning tables if they contain any values
TRUNCATE TABLE shalia.sales_report_total_daily;
TRUNCATE TABLE shalia.sales_report_total_monthly;
TRUNCATE TABLE shalia.sales_report_total_yearly;

--daily report
INSERT INTO shalia.sales_report_total_daily
    SELECT orderdate date_report, onlineorderflag, SUM(subtotal) sum_total, 
			AVG(subtotal) avg_total, COUNT(salesorderid) qty_orders  
      FROM sales.salesorderheader
     WHERE DATE_PART('year', AGE(orderdate)) <= period_years
     GROUP BY onlineorderflag, date_report 
     ORDER BY date_report;
 
-- monthly report
INSERT INTO shalia.sales_report_total_monthly
    SELECT date_trunc('month', orderdate) date_report, onlineorderflag, 
			SUM(subtotal) sum_total, AVG(subtotal) avg_total, COUNT(salesorderid) qty_orders
      FROM sales.salesorderheader
     WHERE DATE_PART('year', AGE(orderdate)) <= period_years
     GROUP BY onlineorderflag, date_report
     ORDER BY date_report;

-- yearly report
INSERT INTO shalia.sales_report_total_yearly
    SELECT date_trunc('year', orderdate) date_report, onlineorderflag, 
			SUM(subtotal) sum_total, AVG(subtotal) avg_total, COUNT(salesorderid) qty_orders
      FROM sales.salesorderheader
     WHERE DATE_PART('year', AGE(orderdate)) <= period_years
     GROUP BY onlineorderflag, date_report
     ORDER BY date_report;
END$$; 

--test procedure
CALL shalia.generate_reports_task3(10)
SELECT * FROM shalia.sales_report_total_daily
SELECT * FROM shalia.sales_report_total_monthly
SELECT * FROM shalia.sales_report_total_yearly