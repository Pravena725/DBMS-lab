-- week 9-10 p2.sql

drop database week9;
create database week9;

\c week9;


CREATE TABLE ORDERS
(	item_id INT NOT NULL ,
	item_name VARCHAR(30) NOT NULL, 
    	quantity DECIMAL(6,2), 
    	price INT NOT NULL,

	PRIMARY KEY (item_id)              );



CREATE TABLE SUMMARY
 (	total_items INT DEFAULT 0,
    total_price DECIMAL(7,2) DEFAULT 0.00              );

INSERT INTO summary VALUES (0,0);

--Trigger Functions
CREATE FUNCTION ins_ord()
	RETURNS trigger as $$
	BEGIN
		UPDATE summary
		SET total_items = total_items + NEW.quantity;
		--WHERE dept_id = NEW.dept_id;
        UPDATE summary
		SET total_price = total_price + NEW.price*NEW.quantity;
		RETURN NEW;
	END;
	$$
	LANGUAGE 'plpgsql';

	CREATE FUNCTION del_ord()
	RETURNS trigger as $$
	BEGIN
		UPDATE summary
		SET total_items = total_items - OLD.quantity;
        UPDATE summary
		SET total_price = total_price - OLD.price*OLD.quantity;
		RETURN OLD;
	END;
	$$
	LANGUAGE 'plpgsql';



-- Creating triggers

CREATE TRIGGER insertItem
	AFTER INSERT ON orders
	FOR EACH ROW
	EXECUTE PROCEDURE ins_ord();

CREATE TRIGGER deleteItem
	BEFORE DELETE ON orders
	FOR EACH ROW
	EXECUTE PROCEDURE del_ord();

