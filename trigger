create table testTrigger(
ID int primary key,
Day_Test date
);
insert into testTrigger values(3,'1/1/2021');

CREATE TABLE storage (
    id INT PRIMARY KEY ,
    product_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);


CREATE TABLE orders_Test (
    id INT PRIMARY KEY ,
    customer_name VARCHAR(50) NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);





/* Trigger basic to update current time every time we insert */
CREATE TRIGGER Update_Curent_trigger ON testTrigger FOR insert
as

BEGIN   
	update testTrigger set  Day_Test   = CURRENT_TIMESTAMP ;
END

drop trigger delete_trigger


/* Trigger basic to update quantity form storage every time we insert into orders */
CREATE TRIGGER autoUpdate_trigger ON testTrigger FOR insert
as
	
BEGIN   
	UPDATE storage
SET quantity = quantity - (
    SELECT quantity
    FROM orders_Test
    WHERE id = (SELECT MAX(id) FROM orders_Test)
)
WHERE product_name IN (
    SELECT product_name
    FROM orders_Test
    WHERE id = (SELECT MAX(id) FROM orders_Test)
)
END 

