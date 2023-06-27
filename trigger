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


use BirdPlatform

/*
drop FUNCTION dbo.CalculateAverageStar(int ID)
Funtion tính average rate cho 1 biến productID truyền vào
Nếu muốn dùng :SELECT dbo.CalculateAverageStar(123) AS average_star;
*/
CREATE FUNCTION dbo.CalculateAverageStar(@ID INT)
  RETURNS DECIMAL(10,2)
  AS
  BEGIN
    DECLARE @average DECIMAL(10,2);
    
    SELECT @average = AVG(star)
    FROM feedback
    WHERE productID = @ID;
    
    RETURN @average;
  END;


/*
drop FUNCTION dbo.ShopCalculateAverageStar(int ID)
Funtion tính average rate cho 1 biến productID truyền vào
Nếu muốn dùng :SELECT dbo.ShopCalculateAverageStar(123) AS average_star;
*/
CREATE FUNCTION dbo.ShopCalculateAverageStar(@ID INT)
  RETURNS DECIMAL(10,2)
  AS
  BEGIN
    DECLARE @average DECIMAL(10,2);
    
    SELECT @average = AVG(rating)
    FROM product
    WHERE shopID = @ID;
    
    RETURN @average;
  END;

/* Update rating của shop 
	drop trigger Update_Rating_trigger;
	Mỗi lần bảng product được update, shopID được lưu vào biến @ID thông qua productID ở feedback từ max feedbackID dc inert(do identity)
	sau đó truyền productID cho funtion dc khai báo ở trên, tính avg rating mới, sau đó update bảng product
	*/
CREATE TRIGGER Update_Rating_trigger ON feedback FOR insert
as
BEGIN  

	Declare @ProductID int;
	select @ProductID = (select productID from Feedback where feedbackID
	=( select max(feedbackID) from feedback	)
	);

	Declare @ShopID int;
	select @ShopID = (select shopID from Product where productID = @ProductID);


	update Product set  product.rating = (select dbo.CalculateAverageStar(@ProductID))
	where Product.productID = @ProductID
	;

	update shop set shop.rate = (select dbo.ShopCalculateAverageStar(@ShopID))
	where shop.shopID =@ShopID;
	
END

/*

Muốn test thì thử 3 hàm này
select * from Feedback
select * from product
select * from shop

insert into Feedback values('img',2,'productID:1' ,1,1,CURRENT_TIMESTAMP)
*/


















