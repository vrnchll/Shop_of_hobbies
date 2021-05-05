--package_user--
CREATE OR REPLACE PACKAGE package_user
IS
    --user
   PROCEDURE Register_user(UserName USERS.LOGIN%TYPE,PasswordUser USERS.PASSWORD%TYPE);
   PROCEDURE LoginUser (LoginUser USERS.LOGIN%TYPE, PasswordUser USERS.PASSWORD%TYPE);
   PROCEDURE UpdatePassword (UserId USERS.ID_USER%TYPE, NewPassword USERS.Password%type);
   PROCEDURE UpdateLogin (UserId USERS.ID_USER%TYPE, NewLogin USERS.LOGIN%type);
   PROCEDURE ShowInfoUser(IdUser USERS.ID_USER%TYPE);
     --
     --orders--
   PROCEDURE AddOrder(CustomerId ORDERS.CUSTOMER_ID%TYPE,DeliveryId ORDERS.DELIVERYMETHOD_ID%TYPE,PaymentId ORDERS.PAYMENTMETHOD_ID%TYPE,AddressUsr ORDERS.ADDRESS%TYPE,CityId ORDERS.CITY_ID%TYPE);
   PROCEDURE RepealOrder(IdOrder ORDERS.ID_ORDER%TYPE);
     --
     --products--
   PROCEDURE GetAllProducts;
      --
     --productCategory--
   PROCEDURE GetAllCategory;
      --
    --deliverymethod--
        PROCEDURE GetAllDeliveryMethod;
      --
    --paymentmethod--
        PROCEDURE GetAllPayMethod;
      --
    --cart--
    PROCEDURE AddToCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE,IdProduct PRODUCTS.ID_PRODUCT%TYPE);
    PROCEDURE GetProductsInCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
    PROCEDURE UpdateProdInCart(CartId CART.ID_CART%TYPE, ProdId CART.PRODUCT_ID%TYPE);
    PROCEDURE DeleteProdFromCart(IdProduct CART.PRODUCT_ID%TYPE, IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
      --
    --customers--
        PROCEDURE AddCustomer(CustFirstName CUSTOMERS.FIRST_NAME%TYPE,CustMiddleName CUSTOMERS.MIDDLE_NAME%TYPE,CustLastName CUSTOMERS.LAST_NAME%TYPE,CustGenger CUSTOMERS.GENDER%TYPE,CustPhoneNumb CUSTOMERS.PHONE_NUMBER%TYPE,CustEmail CUSTOMERS.EMAIL%TYPE,CustUserId CUSTOMERS.USER_ID%TYPE);
        PROCEDURE DeleteCustomers(idCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
        PROCEDURE ShowInfoСustomer(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
        PROCEDURE GetHistoryOrderedCustomer(IdCust History_orders.CUSTOMERID%type);
        PROCEDURE UpdateCustomers(IdCust CUSTOMERS.ID_CUSTOMER%TYPE,FirstNameCust CUSTOMERS.FIRST_NAME%TYPE,MiddleNameCust CUSTOMERS.MIDDLE_NAME%TYPE, LadtNameCust CUSTOMERS.LAST_NAME%TYPE, gender CUSTOMERS.GENDER%TYPE,phoneNumb CUSTOMERS.PHONE_NUMBER%TYPE,email CUSTOMERS.EMAIL%TYPE,userId CUSTOMERS.USER_ID%TYPE);
      --
    --function--
        FUNCTION GetUserId (CustId CUSTOMERS.ID_CUSTOMER%TYPE) RETURN INTEGER;
        FUNCTION GetAvailableProducts(IdProduct PRODUCTS.ID_PRODUCT%TYPE) RETURN INT;
        FUNCTION GetProductId (ProName PRODUCTS.PRODUCT_NAME%TYPE) RETURN INTEGER;
END package_user;


CREATE OR REPLACE PACKAGE BODY package_user
AS
    ---------------------------------Users-----------------------
 ------------------Регистрация USER------------------
PROCEDURE Register_user
(
UserName USERS.LOGIN%TYPE,
PasswordUser USERS.PASSWORD%TYPE
)
IS
BEGIN
        INSERT INTO USERS(TYPE_OF_USER,LOGIN,PASSWORD,ACTIVE) VALUES ('USER',UserName,PasswordUser,1);
        commit;
        DBMS_OUTPUT.PUT_LINE('Пользователь успешно зарегестрирован!');
EXCEPTION
    when others then
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end Register_user;
-----------------------------------------------
    ------------------Вход---------------------
PROCEDURE LoginUser (LoginUser USERS.LOGIN%TYPE, PasswordUser USERS.PASSWORD%TYPE)
IS
    logInuSR USERS%rowtype;
BEGIN
    select * into logInuSR from USERS WHERE LOGIN=LoginUser AND PASSWORD=PasswordUser;
    if(logInuSR.LOGIN=LoginUser and logInuSR.PASSWORD=PasswordUser) then
    DBMS_OUTPUT.PUT_LINE('Вход выполнен успешно.'||' '||'USERNAME: '||logInuSR.LOGIN ||' '||'ROLE:'||logInuSR.TYPE_OF_USER);
    end if;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Пользователя не существует');
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end LoginUser;
 ----------------------------------------------------
----------------------Изменение пароля---------------------
PROCEDURE UpdatePassword (UserId USERS.ID_USER%TYPE, NewPassword USERS.Password%type)
IS
    USR USERS%rowtype;
BEGIN
    SELECT * INTO USR FROM USERS WHERE ID_USER=UserId;
    UPDATE Users Set PASSWORD = NewPassword where Users.ID_USER = UserId;
    commit;
    DBMS_OUTPUT.PUT_LINE('Пароль успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Пользователя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdatePassword;
-------------------------------------------------------
--------------------Изменение логина-------------------
PROCEDURE UpdateLogin (UserId USERS.ID_USER%TYPE, NewLogin USERS.LOGIN%type)
IS
    USR USERS%rowtype;
BEGIN
    SELECT * INTO USR FROM USERS WHERE ID_USER=UserId;
    UPDATE Users Set LOGIN = NewLogin where Users.ID_USER = UserId;
    commit;
    DBMS_OUTPUT.PUT_LINE('Логин успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Пользователя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdateLogin;
      --
     --Получение информации о пользователе--
PROCEDURE ShowInfoUser(IdUser USERS.ID_USER%TYPE)
IS
    Usr USERS%ROWTYPE;
BEGIN
    SELECT * INTO Usr FROM USERS WHERE ID_USER=IdUser;
    DBMS_OUTPUT.PUT_LINE('IdUser: '||' '||Usr.ID_USER||' '||'UserName: '||' '||Usr.LOGIN||' '||'Password: '||' '||Usr.PASSWORD);
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Такого пользователя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END ShowInfoUser;
      ---------------------------------------------
      ------------------Orders---------------------

--------Добавление заказа-------------
PROCEDURE AddOrder
(
CustomerId ORDERS.CUSTOMER_ID%TYPE,
DeliveryId ORDERS.DELIVERYMETHOD_ID%TYPE,
PaymentId ORDERS.PAYMENTMETHOD_ID%TYPE,
AddressUsr ORDERS.ADDRESS%TYPE,
CityId ORDERS.CITY_ID%TYPE
)
IS
    custID ORDERS.CUSTOMER_ID%TYPE;
    delId ORDERS.DELIVERYMETHOD_ID%TYPE;
    payId ORDERS.PAYMENTMETHOD_ID%TYPE;
    citId ORDERS.CITY_ID%TYPE;
BEGIN
select ID_CUSTOMER into custID from CUSTOMERS where ID_CUSTOMER=CustomerId;
select ID_DELIVERY into delId from DELIVERYMETHOD where ID_DELIVERY=DeliveryId;
select ID_PAYMENT into payId from PAYMENTMETHOD where ID_PAYMENT=PaymentId;
select ID_CITY into citId from CITIES where ID_CITY=CityId;
INSERT INTO ORDERS(CUSTOMER_ID,DELIVERYMETHOD_ID,PAYMENTMETHOD_ID,ADDRESS,CITY_ID,STATUS_ID)
VALUES (CustomerId,DeliveryId,PaymentId,AddressUsr,CityId,3);
commit;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Введены несуществующие данные');
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddOrder;
 -------------------------------------
---------------Отмена заказа-------------
PROCEDURE RepealOrder  (IdOrder ORDERS.ID_ORDER%TYPE)
IS
    IdOrd ORDERS.ID_ORDER%TYPE;
BEGIN
select ID_ORDER into IdOrd from ORDERS where ID_ORDER=IdOrder;
UPDATE ORDERS SET STATUS_ID=5 WHERE ID_ORDER=IdOrder;
commit;
--rollback;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Введены несуществующие данные');
     WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END RepealOrder;

----------------------------------------------------------
---------------------------------------PRODUCTS----------------------------
---------Получение всех товаров-------
PROCEDURE GetAllProducts
IS
    AllProducts PRODUCTS%rowtype;
    CURSOR get_products_curs IS SELECT * FROM PRODUCTS where CANORDER=1;
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

   ---------------------------------------------------
   -------------------------PRODUCT_CATEGORY----------

----------Получение всех категорий------------
PROCEDURE GetAllCategory
IS
    AllCategories PRODUCTCATEGORY%rowtype;
    CURSOR get_category_curs IS SELECT * FROM PRODUCTCATEGORY;
BEGIN
    OPEN get_category_curs;
    FETCH get_category_curs INTO AllCategories;
    WHILE get_category_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(AllCategories.ID_CATEGORY || ' ' || AllCategories.CATEGORY_NAME);
        FETCH get_category_curs INTO AllCategories;
        END LOOP;
    close get_category_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetAllCategory;
      ---------------------------------------------------------
    ----------------------------DeliveryMethod---------------
    --Просмотр методов доставки--
PROCEDURE GetAllDeliveryMethod
IS
    AllMethod DELIVERYMETHOD%rowtype;
    CURSOR get_delivery_curs IS SELECT * FROM DELIVERYMETHOD;
BEGIN
    OPEN get_delivery_curs;
    FETCH get_delivery_curs INTO AllMethod;
    WHILE get_delivery_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE('IdStatus:'||' '||AllMethod.ID_DELIVERY|| ' ' ||'DeliveryMethodName:'||' '|| AllMethod.DELIVERY_METHOD|| ' ' ||'DeliveryPrice:'||' '|| AllMethod.DELIVERY_PRICE);
        FETCH get_delivery_curs INTO AllMethod;
        END LOOP;
    close get_delivery_curs;
EXCEPTION
     WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
 END GetAllDeliveryMethod;
    ----------------------------------------------------
    ----------------------PaymentMethod----------------
    --Просмотр методов оплаты--
PROCEDURE GetAllPayMethod
IS
    AllMethod PAYMENTMETHOD%rowtype;
    CURSOR get_pay_curs IS SELECT * FROM PAYMENTMETHOD;
BEGIN
    OPEN get_pay_curs;
    FETCH get_pay_curs INTO AllMethod;
    WHILE get_pay_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE('IdStatus:'||' '||AllMethod.ID_PAYMENT|| ' ' ||'PaymentMethodName:'||' '|| AllMethod.PAYMENTMETHOD_NAME);
        FETCH get_pay_curs INTO AllMethod;
        END LOOP;
    close get_pay_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end  GetAllPayMethod;
    --------------------------------------------------------
--------------------------------------Cart--------------------------
----------------Добавление в корзину--
PROCEDURE AddToCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE,IdProduct PRODUCTS.ID_PRODUCT%TYPE)
IS
    Prod PRODUCTS.CANORDER%TYPE;
    Cust CUSTOMERS.ACTIVE%TYPE;
BEGIN
    SELECT CANORDER INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=IdProduct;
    SELECT ACTIVE INTO Cust FROM CUSTOMERS WHERE ID_CUSTOMER=IdCustomer;
    IF(Prod=1 AND Cust=1) THEN
    INSERT INTO CART(CUSTOMER_ID,PRODUCT_ID) values (IdCustomer,IdProduct);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Данные неактивны');
    END IF;
    commit;
EXCEPTION
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END AddToCart;

------------------------------------------
--------------Просмотр корзины------------
PROCEDURE GetProductsInCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
    AllProducts CART%rowtype;
    CURSOR get_product_curs IS SELECT * FROM CART where CUSTOMER_ID= IdCustomer;
BEGIN
    OPEN get_product_curs;
    FETCH get_product_curs INTO AllProducts;
    WHILE get_product_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE('Id_cart'||' '||AllProducts.ID_CART || ' ' || 'Id_customer'||' '||AllProducts.CUSTOMER_ID || ' ' ||'Id_product'||' '|| AllProducts.PRODUCT_ID) ;
        FETCH get_product_curs INTO AllProducts;
        END LOOP;
    close get_product_curs;
EXCEPTION
     WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetProductsInCart;
---------------------------------------------
-----------------Изменение товара в корзине--
PROCEDURE UpdateProdInCart(CartId CART.ID_CART%TYPE, ProdId CART.PRODUCT_ID%TYPE)
IS
    Cart_Id CART.ID_CART%TYPE;
BEGIN
    SELECT ID_CART INTO Cart_Id FROM CART WHERE ID_CART=CartId;
	Update CART Set PRODUCT_ID = ProdId Where ID_CART=CartId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данного товара в корзине нет');
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdateProdInCart;

-----------------------------------
--------Удаление товара из корзины--
PROCEDURE DeleteProdFromCart(IdProduct CART.PRODUCT_ID%TYPE, IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
    Cart_ CART.PRODUCT_ID%TYPE;
BEGIN
    SELECT PRODUCT_ID INTO Cart_ FROM CART WHERE PRODUCT_ID=IdProduct and CUSTOMER_ID=IdCustomer;
    DELETE FROM CART WHERE CUSTOMER_ID=IdCustomer and PRODUCT_ID=IdProduct;
    commit;
        EXCEPTION
 WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данного товара в корзине нет');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteProdFromCart;

---------------------------------------------------------------------------
------------------------------------------CUSTOMERS------------------------

----------------Добавление покупателя--
PROCEDURE AddCustomer(
CustFirstName CUSTOMERS.FIRST_NAME%TYPE,
CustMiddleName CUSTOMERS.MIDDLE_NAME%TYPE,
CustLastName CUSTOMERS.LAST_NAME%TYPE,
CustGenger CUSTOMERS.GENDER%TYPE,
CustPhoneNumb CUSTOMERS.PHONE_NUMBER%TYPE,
CustEmail CUSTOMERS.EMAIL%TYPE,
CustUserId CUSTOMERS.USER_ID%TYPE)
IS
    Usr USERS%ROWTYPE;
BEGIN
    SELECT * INTO Usr FROM USERS WHERE ID_USER=CustUserId;
    IF(Usr.ACTIVE=1) THEN
    INSERT INTO CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
    values (CustFirstName,CustMiddleName,CustLastName,CustGenger,CustPhoneNumb,CustEmail,CustUserId,1);
    ELSE
        raise_application_error(-20201,'Данные неактивны');
    END IF;
    commit;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данного пользователя не существует');
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END AddCustomer;
----------------------------------------
-------------------Удаление покупателя--
PROCEDURE DeleteCustomers(idCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
is
BEGIN
    UPDATE CUSTOMERS SET ACTIVE=0 WHERE ID_CUSTOMER=idCustomer;
    commit;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данных не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteCustomers;
-----------------------------------------------
-------------Получить информацию о покупателе--
PROCEDURE ShowInfoСustomer(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
    Cust CUSTOMERS%ROWTYPE;
BEGIN
    SELECT * INTO Cust FROM CUSTOMERS WHERE ID_CUSTOMER=IdCustomer;
    DBMS_OUTPUT.PUT_LINE('IdCustomer:'||' '||Cust.ID_CUSTOMER||' '||'FirstName:'||' '||Cust.FIRST_NAME||' '||'MiddleName:'||' '||Cust.MIDDLE_NAME||' '||'LastName:'||' '||Cust.LAST_NAME||' '||'Gender:'||' '||Cust.GENDER||' '||'PhoneNumber:'||' '||Cust.PHONE_NUMBER||' '||'Email:'||' '||Cust.EMAIL||' '||'UserId:'||' '||Cust.USER_ID);
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Такого покупателя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end ShowInfoСustomer;
    ----------------------------------------
    ------------История заказов покупателя--
PROCEDURE GetHistoryOrderedCustomer(IdCust History_orders.CUSTOMERID%type)
IS
    History History_orders%rowtype;
    CURSOR history_orders_curs IS SELECT * FROM HISTORY_ORDERS where CUSTOMERID=IdCust;
BEGIN
    OPEN history_orders_curs;
    FETCH history_orders_curs INTO History;
    WHILE history_orders_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(History.ID_HISTORY_ORDER || ' ' || History.ORDERID || ' ' || History.CREATEAT || ' ' || History.CUSTOMERID || ' ' || History.OPERATION);
        FETCH history_orders_curs INTO History;
        END LOOP;
    close history_orders_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetHistoryOrderedCustomer;
    --------------------------
    ---------UpdateCustomer---
     PROCEDURE UpdateCustomers(IdCust CUSTOMERS.ID_CUSTOMER%TYPE,FirstNameCust CUSTOMERS.FIRST_NAME%TYPE,MiddleNameCust CUSTOMERS.MIDDLE_NAME%TYPE, LadtNameCust CUSTOMERS.LAST_NAME%TYPE, gender CUSTOMERS.GENDER%TYPE,phoneNumb CUSTOMERS.PHONE_NUMBER%TYPE,email CUSTOMERS.EMAIL%TYPE,userId CUSTOMERS.USER_ID%TYPE)
IS
            Cust CUSTOMERS.ID_CUSTOMER%TYPE;
BEGIN
    select ID_CUSTOMER into Cust from CUSTOMERS where ID_CUSTOMER=IdCust;
    UPDATE CUSTOMERS SET FIRST_NAME = FirstNameCust, MIDDLE_NAME=MiddleNameCust, LAST_NAME=LadtNameCust, GENDER=gender,PHONE_NUMBER=phoneNumb,EMAIL=email,USER_ID=userId WHERE ID_CUSTOMER=IdCust;
    commit;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Такого покупателя не существует');
    WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end UpdateCustomers;
    ---------------------------------
    -----------------------------------FUNCTIONS----------------
FUNCTION GetUserId (CustId CUSTOMERS.ID_CUSTOMER%TYPE)
RETURN INTEGER IS Id INTEGER;
BEGIN
SELECT USER_ID INTO Id FROM CUSTOMERS WHERE CustId = ID_CUSTOMER;
RETURN Id;
EXCEPTION
    when others then return -1;
END GetUserId;
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
SELECT COUNT_OF_PRODUCTS INTO FullCount FROM PRODUCTS  where ID_PRODUCT=IdProduct;

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

    END package_user;
