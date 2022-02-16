/* 2. Выбрать все колонки из таблицы HumanResources.Department, 
где в колонке GroupName значение содержит слово “Research” 
в любом месте, отсортированные по DepartmentId 
в обратном порядке
*/
SELECT * 
  FROM HumanResources.Department
 WHERE groupname LIKE '%Research%'
 ORDER BY departmentid DESC;

/* 3. Выбрать HumanResources.Employee колонки 
BusinessEntityId, JobTitle, BirthDate, Gender, 
для которых BusinessEntityId имеет значение
больше 50 и меньше 100 включительно
*/
SELECT BusinessEntityId, JobTitle, BirthDate, Gender
  FROM HumanResources.Employee
 WHERE BusinessEntityId BETWEEN 50 and 100;

/* 4. Выбрать из таблицы HumanResources.Employee колонки 
BusinessEntityId, JobTitle, BirthDate, Gender, 
у которых год рождения (из BirthDate) равен 1980 или 1990. 
Для того, чтобы получить год из даты рождения, 
используйте функцию DATE_PART()
*/

SELECT BusinessEntityId, JobTitle, BirthDate, Gender
  FROM HumanResources.Employee
 WHERE DATE_PART('year', BirthDate) IN (1980, 1990);
 
/* 5. Выбрать из таблицы HumanResources.EmployeeDepartmentHistory колонки 
BusinessEntityId, ShiftId, сгрупированные по BusinessEntityId, ShiftId
*/

SELECT BusinessEntityId, ShiftId
  FROM HumanResources.EmployeeDepartmentHistory
  GROUP BY BusinessEntityId, ShiftId;

/* 6. Дополните предыдущий запрос, чтобы в выдаче остались только те группы,
в которых количество записей больше или равно двум (используйте функцию COUNT())
*/

SELECT BusinessEntityId, ShiftId
  FROM HumanResources.EmployeeDepartmentHistory
  GROUP BY BusinessEntityId, ShiftId
  HAVING COUNT(*) >= 2;