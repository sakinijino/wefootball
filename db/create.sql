drop database if exists wefootball_development;
create database wefootball_development;
drop database if exists wefootball_test;
create database wefootball_test;
drop database if exists wefootball_production;
create database wefootball_production;
GRANT ALL PRIVILEGES ON wefootball_development.* TO 'wefootball'@'localhost'
  IDENTIFIED BY 'YourPasswordHere' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON wefootball_test.* TO 'wefootballl'@'localhost'
  IDENTIFIED BY 'YourPasswordHere' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON wefootball_production.* TO 'wefootball'@'localhost'
  IDENTIFIED BY 'YourPasswordHere' WITH GRANT OPTION;