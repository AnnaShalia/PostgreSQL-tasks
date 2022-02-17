/* 1.1. Выберите имя и фамилию, должность (Job Title), 
дату рождения, используя таблицы [Person].[Person] и [HumanResources].[Employee]. 
Записи должны иметь соответствие в правой и левой таблице*/

SELECT p.firstname, p.lastname, e.jobtitle, e.birthdate
  FROM person.person p
INNER JOIN humanresources.employee e
    ON p.businessentityid = e.businessentityid


/* 1.2. Выберите имя и фамилию, используя таблицы [Person].[Person], 
и должность (Job Title) подзапросом, используя таблицу [HumanResources].[Employee].*/

SELECT p.firstname, p.lastname, 
 (SELECT e.jobtitle 
    FROM humanresources.employee e
   WHERE p.businessentityid = e.businessentityid)
  FROM person.person p

/* 1.3. Используя запрос из пункта 1.2 удалите из выборки все записи, 
для которых JobTitle является NULL (используя вложенные подзапросы)*/

SELECT p.firstname, p.lastname, 
   (SELECT e.jobtitle 
      FROM humanresources.employee e
     WHERE p.businessentityid = e.businessentityid)
  FROM person.person p 
 WHERE p.businessentityid IN 
   (SELECT e.businessentityid 
      FROM humanresources.employee e)

/* 1.4. Напишите запрос, который вернет все возможные сочетания имени,
 фамилии из таблицы [Person].[Person] 
с должностями из таблицы [HumanResources].[Employee]*/
--здесь я выбрала только уникальные сочетания

SELECT DISTINCT p.firstname, p.lastname, e.jobtitle
           FROM person.person p 
     CROSS JOIN humanresources.employee e

/* 1.5. Используя функцию COUNT() напишите запрос, 
который выведет количество записей из запроса 1.4 */

SELECT COUNT(*) 
        FROM 
(SELECT DISTINCT p.firstname, p.lastname, e.jobtitle
            FROM person.person p 
      CROSS JOIN humanresources.employee e) c
     
