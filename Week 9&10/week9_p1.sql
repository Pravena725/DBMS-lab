-- week 9-10 p1.sql

drop database week9;
create database week9;

\c week9;

CREATE TABLE employee 
(	Fname VARCHAR(15) NOT NULL ,
	Minit CHAR, 
	Lname VARCHAR(15) NOT NULL, 
	empid INT NOT NULL,
	Gender CHAR,
	Salary INT NOT NULL,
	Dno INT NOT NULL,
	PRIMARY KEY (empid)	       );



CREATE TABLE department
(	Dname VARCHAR(15)  NOT NULL,
	dno INT NOT NULL,
	no_of_employees INT NOT NULL, 

	PRIMARY KEY (dno),
	UNIQUE (Dname)			);


ALTER TABLE employee add FOREIGN KEY (dno) REFERENCES DEPARTMENT(dno);	


CREATE FUNCTION ins_emp()
	RETURNS trigger as $$
	BEGIN
		UPDATE department
		SET no_of_employees = no_of_employees + 1
		WHERE dno = NEW.dno;
		RETURN NEW;
	END;
	$$
	LANGUAGE 'plpgsql';

	CREATE FUNCTION del_emp()
	RETURNS trigger as $$
	BEGIN
		UPDATE department
		SET no_of_employees = no_of_employees - 1
		WHERE dno = OLD.dno;
		RETURN OLD;
	END;
	$$
	LANGUAGE 'plpgsql';

-- Creating triggers

CREATE TRIGGER insertEmployee
	AFTER INSERT ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE ins_emp();

CREATE TRIGGER deleteEmployee
	BEFORE DELETE ON employee
	FOR EACH ROW
	EXECUTE PROCEDURE del_emp();
	
