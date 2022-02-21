/* 1.1. Выбрать названия и количество групп из таблицы 
HumanResources.Department */

SELECT groupname, COUNT(groupname) group_num
  FROM HumanResources.Department
GROUP BY groupname;

/* 1.2. Найти максимальную ставку для каждого 
сотрудника из таблиц HumanResources.EmployeePayHistory, 
HumanResources.Employee */

SELECT ep.businessentityid, e.jobtitle, MAX(ep.rate)
  FROM HumanResources.EmployeePayHistory ep
  JOIN HumanResources.Employee e
    ON e.businessentityid = ep.businessentityid
GROUP BY ep.businessentityid, e.jobtitle
ORDER BY 1;

/* 1.3. Выбрать минимальную цену единицы товара 
по подкатегориям (названия из таблицы PRODUCTION.PRODUCTSUBCATEGORY,
минимальная цена из таблицы SALES.SALESORDERDETAIL) используя таблицы
Sales.SalesOrderHeader, 
Sales.SalesOrderDetail, 
Production.Product, 
Production.ProductSubcategory */

WITH product_subcat AS
(
  SELECT p.productid, psc.name subcat_name
      FROM production.product p
      JOIN production.productsubcategory psc
        ON p.productsubcategoryid = psc.productsubcategoryid
)
SELECT ps.subcat_name, MIN(sod.unitprice) min_pr_price
  FROM sales.salesorderdetail sod
  JOIN product_subcat ps
    ON ps.productid = sod.productid
GROUP BY ps.subcat_name
ORDER BY 2;

/* 1.4. Вычислить название и количество подкатегорий товара в 
каждой категории, используя таблицы 
Production.ProductCategory, Production.ProductSubcategory */

SELECT pc.name category, COUNT(DISTINCT psc.productsubcategoryid) subcategory_num
  FROM production.productcategory pc
  JOIN production.productsubcategory psc
    ON pc.productcategoryid = psc.productcategoryid
 GROUP BY category;

/* 1.5. Вывести среднюю сумму заказа по подкатегориям товаров, 
используя таблицы 
Sales.SalesOrderHeader, 
Sales.SalesOrderDetail, 
Production.Product, 
Production.ProductSubcategory
*/

WITH product_subcat AS
(
  SELECT p.productid, psc.name subcat_name
      FROM production.product p
      JOIN production.productsubcategory psc
        ON p.productsubcategoryid = psc.productsubcategoryid
)
SELECT ps.subcat_name, AVG(sod.linetotal)::numeric(6,2) avg_total
  FROM sales.salesorderdetail sod
  JOIN product_subcat ps
    ON ps.productid = sod.productid
GROUP BY ps.subcat_name
ORDER BY 2;


/* 1.6. Найти ID сотрудника с максимальным рейтом и дату назначения 
рейта, используя таблицы HumanResources.EmployeePayHistory */

SELECT businessentityid, ratechangedate
  FROM HumanResources.EmployeePayHistory
 WHERE rate = 
(
  SELECT MAX(rate) 
    FROM HumanResources.EmployeePayHistory
);