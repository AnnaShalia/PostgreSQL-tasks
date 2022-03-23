/*1. Создайте таблицу Customer со следующими колонками:
CustomerID int,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100),
ModifiedDate date,
Age int,
active boolean*/

CREATE TABLE shalia.customer(
    CustomerID int,
    FirstName varchar(50),
    LastName varchar(50),
    Email varchar(100),
    ModifiedDate date,
    Age int,
    active boolean);

/* На колонке CustomerID создайте ограничение первичного ключа и индекс типа B-tree*/

   ALTER TABLE shalia.customer 
ADD CONSTRAINT pk_customerid PRIMARY KEY(CustomerID);

CREATE INDEX ix_customer_id 
          ON shalia.customer(CustomerID);

/*Заполните ее тестовыми данными, например:
INSERT INTO [schema].customer 
SELECT 
  businessentityid AS customerid,
  concat('firstname', businessentityid) AS firstname,
  concat('lastname', businessentityid) AS lastname,
  concat('firstname', businessentityid, 'lastname', businessentityid, '@email.com') AS email,
  modifieddate,
  DATE_PART('year', now()::date) - DATE_PART('year', birthdate::date) AS age,
  CASE WHEN businessentityid % 7 = 0 THEN False ELSE True END AS active
FROM humanresources.employee*/

INSERT INTO shalia.customer 
SELECT 
  businessentityid AS customerid,
  concat('firstname', businessentityid) AS firstname,
  concat('lastname', businessentityid) AS lastname,
  concat('firstname', businessentityid, 'lastname', businessentityid, '@email.com') AS email,
  modifieddate,
  DATE_PART('year', now()::date) - DATE_PART('year', birthdate::date) AS age,
  CASE WHEN businessentityid % 7 = 0 THEN False ELSE True END AS active
  FROM humanresources.employee;

/*2. Удостоверьтесь, что ваш индекс появился в системном каталоге pg_indexes*/

SELECT * 
  FROM pg_indexes
 WHERE schemaname = 'shalia';

/*3. Создайте составной индекс типа B-tree на таблице Customer на колонках FirstName и LastName*/

CREATE INDEX ix_customer_name 
          ON shalia.customer(firstname, lastname);

/*4. Создайте такой индекс на таблице Customer, чтобы результат выполнения запроса 
explain (analyze)
select *
from shalia.customer
where age between 30 and 60
был:
"Index Scan using ix_customer_age on customer  (...)"
"  Index Cond: ((age >= 30) AND (age <= 60))"*/

CREATE INDEX ix_customer_age 
          ON shalia.customer(age);

/*5. Создайте покрывающий индекс IX_Customer_ModifiedDate для быстрого 
выполнения запроса и проверьте, что он используется в плане запроса:
SELECT 
FirstName,
LastName
FROM shalia.Customer
WHERE ModifiedDate = '2020-10-20'*/

CREATE INDEX IX_Customer_ModifiedDate 
          ON shalia.customer(modifieddate)
     INCLUDE (firstname, lastname);

EXPLAIN ANALYSE
 SELECT FirstName,LastName
   FROM shalia.Customer
  WHERE ModifiedDate = '2020-10-20';

/*6. Удалите индекс PK_CustomerID из таблицы Customer*/

DROP INDEX ix_customer_id;

    ALTER TABLE shalia.customer 
DROP CONSTRAINT pk_customerid;

/*7. Создайте индекс типа Hash с названием PK_ Modified_Date в таблице Customer на колонке ModifiedDate*/

CREATE INDEX pk_modified_date 
          ON shalia.customer 
       USING hash(modifieddate);

/*8. Переименуйте индекс PK_ Modified_Date на PK_ ModifiedDate*/

ALTER INDEX pk_modified_date 
  RENAME TO pk_modifieddate;

/*9. Создайте частичный индекс на колонке email только для тех записей, у которых active = true. 
И напишите запрос к таблице, в котором этот индекс будет использоваться.*/

CREATE INDEX ix_customer_email 
          ON shalia.customer(email)
       WHERE active = TRUE;

--a query to check using explain analyse 
EXPLAIN ANALYSE
 SELECT * 
   FROM shalia.customer
  WHERE email = 'firstname286lastname286@email.com' AND active = true;

/*10. Создайте функциональный индекс в таблице Customer для быстрого поиска записей по такому правилу: 
если  firstname = ‘firstname1’ 
и lastname = ‘lastname1’, то мы ищем ‘f, lastname1’.
Проверьте план запроса, что этот индекс используется.*/

CREATE INDEX ix_customer_fullname 
          ON shalia.customer(((LEFT(LTRIM(firstname), 1)) || ', ' || lastname));

--query to test index
EXPLAIN ANALYSE
 SELECT * 
   FROM shalia.customer
  WHERE (((LEFT(LTRIM(firstname), 1)) || ', ' || lastname = 'f lastname5'));
