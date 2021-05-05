--package_admin_products--
CREATE OR REPLACE PACKAGE package_admin_products
IS
   PROCEDURE AddProduct(ProductName PRODUCTS.PRODUCT_NAME%TYPE,PriceProduct PRODUCTS.PRICE%TYPE,Count PRODUCTS.COUNT_OF_PRODUCTS%TYPE,ShortName PRODUCTS.SHORT_NAME%TYPE,Descript PRODUCTS.DESCRIPTION%TYPE,CategoryId PRODUCTS.CATEGORY_ID%TYPE);
   PROCEDURE DeleteProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE);
   PROCEDURE UpdateProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE,ProdPrice PRODUCTS.PRICE%TYPE,ProdCount PRODUCTS.COUNT_OF_PRODUCTS%TYPE, ProdSName PRODUCTS.SHORT_NAME%TYPE, ProdDesc PRODUCTS.DESCRIPTION%TYPE,ProdCat PRODUCTS.CATEGORY_ID%TYPE,ProdName PRODUCTS.PRODUCT_NAME%TYPE);
   PROCEDURE UpdateProductPrice(ProdId PRODUCTS.ID_PRODUCT%TYPE, PriceProd PRODUCTS.PRICE%TYPE);
   PROCEDURE GetAllProducts;

    FUNCTION GetAvailableProducts(IdProduct PRODUCTS.ID_PRODUCT%TYPE) RETURN INT;
    FUNCTION GetProductId (ProName PRODUCTS.PRODUCT_NAME%TYPE) RETURN INTEGER;
END package_admin_products;


CREATE OR REPLACE PACKAGE BODY package_admin_products
AS
--Добавление товара--
PROCEDURE AddProduct
    (
    ProductName PRODUCTS.PRODUCT_NAME%TYPE,
    PriceProduct PRODUCTS.PRICE%TYPE,
    Count PRODUCTS.COUNT_OF_PRODUCTS%TYPE,
    ShortName PRODUCTS.SHORT_NAME%TYPE,
    Descript PRODUCTS.DESCRIPTION%TYPE,
    CategoryId PRODUCTS.CATEGORY_ID%TYPE
    )
IS
    CATEG PRODUCTCATEGORY%ROWTYPE;
BEGIN
    SELECT * INTO CATEG FROM PRODUCTCATEGORY WHERE ID_CATEGORY=CategoryId;
    IF(CATEG.ACTIVE=1) THEN
    INSERT INTO PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    VALUES (ProductName,PriceProduct,Count,ShortName,Descript,CategoryId,1);
    commit;
    ELSE
        raise_application_error(-20201,'Данные неактивны');
    END IF;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Введены несуществующие данные');
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddProduct;

--Удаление товара--
PROCEDURE DeleteProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE)
IS
    Prod PRODUCTS%ROWTYPE;
BEGIN
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=IdProduct;
    UPDATE PRODUCTS SET CANORDER=0 WHERE ID_PRODUCT=IdProduct;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Товара с таким Id не существует');
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteProduct;

--Изменение информации о товаре--
PROCEDURE UpdateProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE,ProdPrice PRODUCTS.PRICE%TYPE,ProdCount PRODUCTS.COUNT_OF_PRODUCTS%TYPE, ProdSName PRODUCTS.SHORT_NAME%TYPE, ProdDesc PRODUCTS.DESCRIPTION%TYPE,ProdCat PRODUCTS.CATEGORY_ID%TYPE,ProdName PRODUCTS.PRODUCT_NAME%TYPE)
IS
      Prod PRODUCTS%ROWTYPE;
      CATEG PRODUCTCATEGORY%ROWTYPE;
BEGIN
    SELECT * INTO CATEG FROM PRODUCTCATEGORY WHERE ID_CATEGORY=ProdCat;
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=IdProduct;
    UPDATE PRODUCTS SET PRICE = ProdPrice, COUNT_OF_PRODUCTS=ProdCount, SHORT_NAME=ProdSName, DESCRIPTION=ProdDesc,CATEGORY_ID=ProdCat,PRODUCT_NAME=ProdName WHERE ID_PRODUCT=IdProduct;
    commit;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Такого товара или категории не существует');
     WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end UpdateProduct;

--Изменение цены товара--
PROCEDURE UpdateProductPrice(ProdId PRODUCTS.ID_PRODUCT%TYPE, PriceProd PRODUCTS.PRICE%TYPE)
IS
    Prod_Id PRODUCTS.ID_PRODUCT%TYPE;
BEGIN
    SELECT ID_PRODUCT INTO Prod_Id FROM PRODUCTS WHERE ID_PRODUCT =ProdId;
	Update PRODUCTS Set PRICE = PriceProd Where ID_PRODUCT =ProdId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Товара с таким Id не существует');
     WHEN OTHERS THEN
      raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdateProductPrice;

--Получение всех товаров--
PROCEDURE GetAllProducts
IS
    AllProducts PRODUCTS%rowtype;
    CURSOR get_products_curs IS SELECT * FROM PRODUCTS;
BEGIN
    OPEN get_products_curs;
    FETCH get_products_curs INTO AllProducts;
    WHILE get_products_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(AllProducts.ID_PRODUCT || ' ' || AllProducts.PRODUCT_NAME || ' ' || AllProducts.PRICE || ' ' || AllProducts.COUNT_OF_PRODUCTS || ' ' || AllProducts.SHORT_NAME || ' ' || AllProducts.DESCRIPTION || ' ' || AllProducts.CATEGORY_ID);
        FETCH get_products_curs INTO AllProducts;
        END LOOP;
    close get_products_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetAllProducts;

------------------------------------------
----------------------------------------------------------
-----Получение количества доступного товара
FUNCTION GetAvailableProducts
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
countProd:=-FullCount+CountExistingOrders;
RETURN countProd;
 END GetAvailableProducts;

-------------------------------------------------
--------------Поиск id товара по имени-----------
    FUNCTION GetProductId
(ProName PRODUCTS.PRODUCT_NAME%TYPE)
RETURN INTEGER IS Id INTEGER;
BEGIN
SELECT ID_PRODUCT INTO Id FROM PRODUCTS WHERE PRODUCT_NAME = ProName;
RETURN Id;
EXCEPTION
    when others then return -1;
END GetProductId;

    END package_admin_products;