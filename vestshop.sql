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
	('vestshop',1,'boss','Boss',120,'{}','{}'),
;


INSERT INTO `items` (name, label, weight, rare, can_remove) VALUES
    ('iron', 'Iron', 1, 0, 1),
    ('bulletproof', 'Bullet Proof', 1, 0, 1),
;

