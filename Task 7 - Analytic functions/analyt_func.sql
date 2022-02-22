/* 1. Найти сумму продаж за месяц по каждому продукту, проданному в январе-2013 года. 
Вывести итоговый список продуктов без первых и последних 10% списка, используя следующие таблицы:
	Sales.SalesOrderHeader
	Sales.SalesOrderDetail
	Production.Product */

WITH orders AS (
    SELECT od.productid, SUM(od.linetotal) sumtotal
      FROM sales.salesorderheader o
      JOIN sales.salesorderdetail od
        ON o.salesorderid = od.salesorderid
     WHERE to_char(o.orderdate, 'yyyy-mm') = '2013-01'
     GROUP BY od.productid
	), 
	ranked_items AS (
	SELECT p.name product, o.sumtotal, PERCENT_RANK() OVER(ORDER BY o.sumtotal) perrank
	  FROM production.product p
	  JOIN orders o
        ON o.productid = p.productid
	)
SELECT product, sumtotal
  FROM ranked_items
 WHERE perrank > 0.1 AND perrank < 0.9;
 
/* 2. Найти самые дешевые продукты в каждой субкатегории продуктов.
Использовать таблицу Production.Product. */

SELECT name, MIN(listprice) OVER(PARTITION BY productsubcategoryid) listprice
  FROM production.product;

/* 3. Найти вторую по величине цену для горных велосипедов, 
используя таблицу Production.Product */

WITH mountain_bikes AS (
	SELECT DENSE_RANK() OVER(ORDER BY listprice DESC) rnk, listprice 
	  FROM production.product
	 WHERE productsubcategoryid = 1
)
SELECT DISTINCT(listprice) 
  FROM mountain_bikes
 WHERE rnk = 2;

/* 4. Посчитать продажи за 2013 год в разрезе категорий(“YoY метрика”):  
(продажи - продажи за прошлый год) продажи
используя таблицы:
	Sales.SalesOrderHeader
	Sales.SalesOrderDetail
	Production.Product
	Production.ProductSubcategory
	Production.ProductCategory */

WITH categories AS(
		SELECT c.productcategoryid category, c.name, sc.productsubcategoryid 
		  FROM production.productcategory c
		  JOIN production.productsubcategory sc
			ON c.productcategoryid = sc.productcategoryid
	), 
	sales AS(
		SELECT od.productid, od.linetotal, o.orderdate
		  FROM sales.salesorderdetail od
		  JOIN sales.salesorderheader o
			ON od.salesorderid = o.salesorderid
	), 
	categories_sales AS (
<<<<<<< HEAD
		SELECT c.name, SUM(s.linetotal) sales, EXTRACT(YEAR from s.orderdate) order_year
	      FROM categories c
	      JOIN production.product p
=======
        SELECT c.name, SUM(s.linetotal) sales, EXTRACT(YEAR from s.orderdate) order_year
          FROM categories c
          JOIN production.product p
>>>>>>> fcca742 (Task 7. Analytic functions)
		    ON c.productsubcategoryid = p.productsubcategoryid
	      JOIN sales s
		    ON s.productid = p.productid
	  GROUP BY c.name, order_year
	),
	sales_yoy AS (
<<<<<<< HEAD
		SELECT name category, sales, order_year,(sales - LAG(sales) OVER(
=======
        SELECT name category, sales, order_year,(sales - LAG(sales) OVER(
>>>>>>> fcca742 (Task 7. Analytic functions)
			PARTITION BY name ORDER BY order_year)) / sales yoy
          FROM categories_sales
	)
SELECT category, sales, yoy
  FROM sales_yoy
 WHERE order_year = '2013';

/* 5. Найти сумму максимальную заказа за каждый день января 2013, используя таблицы:
	Sales.SalesOrderHeader
	Sales.SalesOrderDetail */

WITH sales AS(
    SELECT o.orderdate, MAX(od.linetotal) total
      FROM sales.salesorderheader o
<<<<<<< HEAD
	  JOIN sales.salesorderdetail od
	    ON o.salesorderid = od.salesorderid
	 WHERE to_char(o.orderdate, 'yyyy-mm')= '2013-01'
	GROUP BY o.orderdate
=======
      JOIN sales.salesorderdetail od
        ON o.salesorderid = od.salesorderid
     WHERE to_char(o.orderdate, 'yyyy-mm')= '2013-01'
     GROUP BY o.orderdate
>>>>>>> fcca742 (Task 7. Analytic functions)
	)
SELECT orderdate, MAX(total) OVER(PARTITION BY orderdate) maxorder
  FROM sales;

/* 6. Найти товар, который чаще всего продавался в каждой из субкатегорий в январе 2013, используя таблицы:
Sales.SalesOrderHeader
	Sales.SalesOrderDetail
	Production.Product
	Production.ProductSubcategory */

WITH sold_products AS (
    SELECT od.productid
      FROM sales.salesorderheader o
      JOIN sales.salesorderdetail od
        ON o.salesorderid = od.salesorderid
     WHERE to_char(o.orderdate, 'yyyy-mm')= '2013-01'
	), 
	sold_product_subcategories AS (
    SELECT s.name, p.name mostfreq, RANK() OVER (
		PARTITION BY s.name ORDER BY COUNT(p.name) DESC) AS rnk 
      FROM production.productsubcategory s
      JOIN production.product p
        ON s.productsubcategoryid = p.productsubcategoryid
      JOIN sold_products sp
        ON sp.productid = p.productid
     GROUP BY s.name, mostfreq
	)
SELECT name, mostfreq 
  FROM sold_product_subcategories
 WHERE rnk = 1
<<<<<<< HEAD
ORDER BY mostfreq;
=======
 ORDER BY mostfreq;
>>>>>>> fcca742 (Task 7. Analytic functions)
