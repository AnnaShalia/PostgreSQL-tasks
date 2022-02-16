/* 3. необходимо прописать команду, которая добавит
значения в нашу таблицу TestTable */
INSERT INTO shalia.testtable
	 VALUES (4,'Bicycle', B'0', '2020-08-23'),
	 		(5, 'Rocket', B'1', '2020-01-01'),
			(6, 'Motorcycle', null, '2020-08-26'),
			(7, 'Submarine', B'0', '1999-05-16');

/* 3. Дополнить скрипт, добавив команды, 
которые вставят значения */
INSERT INTO shalia.testtable(id, invoicedate)
	 VALUES (8, '2020-08-25');
	 
INSERT INTO shalia.testtable(id, name)
	 VALUES (9, 'Scooter');
	 
/* 4. Дополнить скрипт, написав команду,
которая в колонке IsSold поменяет все NULL на 0 */

UPDATE shalia.testtable SET issold = B'0'
 WHERE issold IS NULL;

/* 5. Дополнить скрипт, написав команду, 
которая удалит все строки, в которых значение 
колонки Name или InvoiceDate - NULL */

DELETE FROM shalia.testtable
	  WHERE name IS NULL 
	  OR invoicedate IS NULL;

/* 6. Используя INSERT, выполнить UPSERT, что означает UPDATE или INSERT. 
Это позволит вставить строку если ее нет, или обновить существующую. 
Необходимо этим способом заменить Name Bicycle на Train. Добавить результат в скрипт.
 */

INSERT INTO shalia.testtable 
	 VALUES(4, 'Train', B'0', '2020-08-23' )
	 ON CONFLICT (id)
	 DO UPDATE SET name = EXCLUDED.name
	 -- if we want to return the values that had changes:
	 -- RETURNING *

