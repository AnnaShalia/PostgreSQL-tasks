/* 3.1. Создать представление Person.vPerson, 
которое базируется на таблицах Person.Person и Person.EmailAddress, 
и содержит следующие колонки:
- Title
- FirstName
- LastName
- EmailAddress
*/

CREATE VIEW shalia.vperson 
  AS SELECT p.title, p.firstname, p.lastname, e.emailaddress
       FROM Person.Person p
       JOIN Person.EmailAddress e
         ON p.businessentityid = e.businessentityid;

     
/* 3.2. Напишите запрос, который вернет колонки:
- HumanResources.Employee.BusinessEntityId
- HumanResources.Employee.NationalIdNumber
- HumanResources.Employee.JobTitle
- Person.Person.FirstName
- Person.Person.LastName
- Person.PersonPhone.PhoneNumber
Основная таблица - HumanResources.Employee, Person.Person и Person.PersonPhone
оформить как CTE
*/

WITH people_phones AS (
  SELECT p.businessentityid, p.firstname, p.lastname, ph.phonenumber
    FROM person.person p
    JOIN person.personphone ph 
      ON ph.businessentityid = p.businessentityid
) 
SELECT e.businessentityid, e.nationalidnumber, e.jobtitle, pph.firstname, pph.lastname, pph.phonenumber
  FROM humanresources.employee e
  JOIN people_phones pph
    ON pph.businessentityid = e.businessentityid