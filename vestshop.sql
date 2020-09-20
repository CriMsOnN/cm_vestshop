INSERT INTO `addon_account` (name, label, shared) VALUES
    ('society_vestshop', 'VestShop', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    ('society_vestshop', 'VestShop', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    ('society_vestshop', 'VestShop', 1)
;

INSERT INTO `jobs` (name, label) VALUES
    ('vestshop', 'Vestshop')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('vestshop',0,'recruit','Recruit',35,'{}','{}'),
	('vestshop',1,'guard','Guard',50,'{}','{}'),
	('vestshop',4,'boss','Boss',120,'{}','{}')
;


