--Functions--
--Поиск id пользователя
CREATE OR  REPLACE FUNCTION GetUserId
    (CustId CUSTOMERS.ID_CUSTOMER%TYPE)
RETURN INTEGER IS Id INTEGER;
BEGIN
SELECT USER_ID INTO Id FROM CUSTOMERS WHERE CustId = ID_CUSTOMER;
RETURN Id;
EXCEPTION
    when others then return -1;
END;

--Поиск id товара по имени--
CREATE OR  REPLACE FUNCTION GetProductId
    (ProName PRODUCTS.PRODUCT_NAME%TYPE)
RETURN INTEGER IS Id INTEGER;
BEGIN
SELECT ID_PRODUCT INTO Id FROM PRODUCTS WHERE PRODUCT_NAME = ProName;
RETURN Id;
EXCEPTION
    when others then return -1;
END;

-- --Получение количества доступного товара
CREATE OR  REPLACE FUNCTION GetAvailableProducts
 (IdProduct PRODUCTS.ID_PRODUCT%TYPE)
RETURN INT IS countProd INT;
    FullCount INT;
    CountExistingOrders INT;
    CountAvaliableProd INT;
BEGIN
--Получаем кол-во товара
SELECT COUNT_OF_PRODUCTS INTO FullCount FROM PRODUCTS where ID_PRODUCT=IdProduct;

--Получаем количество существующих заказов данного товара
select SUM(COUNT_OF_PRODUCT) INTO CountExistingOrders from ORDER_DETAILS where ORDER_DETAILS.PRODUCT_ID = IdProduct;

--Получаем количество доступных товаров
countProd:=FullCount-CountExistingOrders;
RETURN countProd;
 END;

