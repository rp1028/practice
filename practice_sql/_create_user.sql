CREATE USER IF NOT EXISTS 'practice'@'%' IDENTIFIED BY 'practice';
CREATE DATABASE IF NOT EXISTS employeedb;

GRANT ALL PRIVILEGES ON employeedb.* TO 'practice'@'%';

FLUSH PRIVILEGES;

SELECT Host, User FROM mysql.user WHERE User = 'practice';
SHOW DATABASES LIKE 'employeedb';
SHOW GRANTS FOR 'practice'@'%';