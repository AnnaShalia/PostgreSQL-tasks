/* 2 */
CREATE TABLE shalia.testtable(
	id INT PRIMARY KEY NOT NULL,
	name TEXT,
	issold BIT,
	invoicedate DATE
);

/* 3 */
INSERT INTO shalia.testtable
VALUES (1,'Boat', B'1', '2021-11-08'),
	   (2,'Auto', B'0', '2021-11-09'),
	   (3,'Plane', null, '2021-12-09');

/* 4 */
ALTER TABLE shalia.testtable 
RENAME COLUMN name to Vehicle;

/* 5 */
TRUNCATE TABLE shalia.testtable;

/* 6 */
DROP TABLE shalia.testtable;