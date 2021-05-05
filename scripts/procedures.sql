--Procedures--

----------------------------------Users-----------------
--Регистрация USER--
CREATE OR REPLACE PROCEDURE Register_user
(
UserName USERS.LOGIN%TYPE,
PasswordUser USERS.PASSWORD%TYPE
)
IS
   --   UserExists EXCEPTION;
--       UsersExisting USERS%ROWTYPE;
BEGIN
--       SELECT * INTO UsersExisting from USERS WHERE LOGIN=UserName;
--       if UsersExisting.LOGIN = UserName
--    --   THEN RAISE UserExists;
--          then DBMS_OUTPUT.PUT_LINE('Пользователь уже существует!');
--       else
        INSERT INTO USERS(TYPE_OF_USER,LOGIN,PASSWORD,ACTIVE) VALUES ('USER',UserName,PasswordUser,1);
        DBMS_OUTPUT.PUT_LINE('Пользователь успешно зарегестрирован!');
--       end if;
EXCEPTION
--       when UserExists
--          then DBMS_OUTPUT.PUT_LINE('Такой пользователь уже существует');
--         -- then raise_application_error(-20001,'Такой пользователь уже существует');
    when others
        then DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Регистрация ADMIN--
CREATE OR REPLACE PROCEDURE Register_user_admin
(
UserName USERS.LOGIN%TYPE,
PasswordUser USERS.PASSWORD%TYPE
)
IS
   --   UserExists EXCEPTION;
--       UsersExisting USERS%ROWTYPE;
BEGIN
--       SELECT * INTO UsersExisting from USERS WHERE LOGIN=UserName;
--       if UsersExisting.LOGIN = UserName
--    --   THEN RAISE UserExists;
--          then DBMS_OUTPUT.PUT_LINE('Пользователь уже существует!');
--       else
        INSERT INTO USERS(TYPE_OF_USER,LOGIN,PASSWORD,ACTIVE) VALUES ('ADMIN',UserName,PasswordUser,1);
        DBMS_OUTPUT.PUT_LINE('Пользователь успешно зарегестрирован!');
--       end if;
EXCEPTION
--       when UserExists
--          then DBMS_OUTPUT.PUT_LINE('Такой пользователь уже существует');
--         -- then raise_application_error(-20001,'Такой пользователь уже существует');
    when others
        then DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;


--Вход--
CREATE OR REPLACE PROCEDURE LoginUser (LoginUser USERS.LOGIN%TYPE, PasswordUser USERS.PASSWORD%TYPE)
IS
    logInuSR USERS%rowtype;
    username  USERS.LOGIN%TYPE;
    pass    USERS.PASSWORD%TYPE;
BEGIN
    select * into logInuSR from USERS WHERE LOGIN=LoginUser AND PASSWORD=PasswordUser;
    select LOGIN into username from USERS;
    select PASSWORD into pass from USERS;
    if(username=LoginUser and pass=PasswordUser) then
    DBMS_OUTPUT.PUT_LINE('Вход выполнен успешно.'||' '||'USERNAME: '||logInuSR.LOGIN ||' '||'ROLE:'||logInuSR.TYPE_OF_USER);
    end if;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Изменение пароля--
CREATE OR REPLACE PROCEDURE UpdatePassword (UserId USERS.ID_USER%TYPE, NewPassword USERS.Password%type)
IS
    USR USERS%rowtype;
BEGIN
    SELECT * INTO USR FROM USERS WHERE ID_USER=UserId;
    UPDATE Users Set PASSWORD = NewPassword where Users.ID_USER = UserId;
    DBMS_OUTPUT.PUT_LINE('Пароль успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;


--изменение логина--
CREATE OR REPLACE PROCEDURE UpdateLogin (UserId USERS.ID_USER%TYPE, NewLogin USERS.LOGIN%type)
IS
    USR USERS%rowtype;
BEGIN
    SELECT * INTO USR FROM USERS WHERE ID_USER=UserId;
    UPDATE Users Set LOGIN = NewLogin where Users.ID_USER = UserId;
    DBMS_OUTPUT.PUT_LINE('Логин успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Удаление пользователя--
CREATE OR REPLACE PROCEDURE DeleteUser(IdUser USERS.ID_USER%TYPE)
IS
    Usr USERS%ROWTYPE;
BEGIN
    SELECT * INTO Usr FROM USERS WHERE ID_USER=IdUser;
    UPDATE USERS SET ACTIVE=0 WHERE ID_USER=IdUser;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Такого пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

    --Получение информации о пользователе--
CREATE OR REPLACE PROCEDURE ShowInfoUser(IdUser USERS.ID_USER%TYPE)
IS
    Usr USERS%ROWTYPE;
BEGIN
    SELECT * INTO Usr FROM USERS WHERE ID_USER=IdUser;
    DBMS_OUTPUT.PUT_LINE('IdUser: '||' '||Usr.ID_USER||' '||'UserName: '||' '||Usr.LOGIN||' '||'Password: '||' '||Usr.PASSWORD);
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Такого пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

        --Получить всех пользователей--
CREATE OR REPLACE PROCEDURE GetAllUsers
IS
    UserInfo USERS%rowtype;
    CURSOR users_curs IS SELECT * FROM USERS;
BEGIN
    OPEN users_curs;
    FETCH users_curs INTO UserInfo;
    WHILE users_curs%FOUND
        LOOP
       DBMS_OUTPUT.PUT_LINE('IdUser: '||' '||UserInfo.ID_USER||' '||'UserName: '||' '||UserInfo.LOGIN||' '||'Password: '||' '||UserInfo.PASSWORD);
        FETCH users_curs INTO UserInfo;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

--История пользователей--
CREATE OR REPLACE PROCEDURE GetHistoryActionUsers
IS
    HistoryAction HISTORY_USER_ACTION%rowtype;
    CURSOR history_actions_curs IS SELECT * FROM HISTORY_USER_ACTION;
BEGIN
    OPEN history_actions_curs;
    FETCH history_actions_curs INTO HistoryAction;
    WHILE history_actions_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(HistoryAction.ID || ' ' || HistoryAction.USERID || ' ' || HistoryAction.USERNAME || ' ' || HistoryAction.OPERATION || ' ' || HistoryAction.CREATEAT);
        FETCH history_actions_curs INTO HistoryAction;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

----------------------------------------------------Orders------------------------------------
--Добавление заказа
CREATE OR REPLACE PROCEDURE AddOrder
(
CustomerId ORDERS.CUSTOMER_ID%TYPE,
DeliveryId ORDERS.DELIVERYMETHOD_ID%TYPE,
PaymentId ORDERS.PAYMENTMETHOD_ID%TYPE,
Address ORDERS.ADDRESS%TYPE,
CityId ORDERS.CITY_ID%TYPE,
StatusId ORDERS.STATUS_ID%TYPE
)
IS
BEGIN
INSERT INTO ORDERS(CUSTOMER_ID,DELIVERYMETHOD_ID,PAYMENTMETHOD_ID,ADDRESS,CITY_ID,STATUS_ID)
VALUES (CustomerId,DeliveryId,PaymentId,Address,CityId,3);
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Отмена заказа--
CREATE OR REPLACE PROCEDURE RepealOrder  (IdOrder ORDERS.ID_ORDER%TYPE)
IS
BEGIN
UPDATE ORDERS SET STATUS_ID=5 WHERE ID_ORDER=IdOrder;
--rollback;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--История заказов--
CREATE OR REPLACE PROCEDURE GetHistoryOrdered
IS
    History History_orders%rowtype;
    CURSOR history_orders_curs IS SELECT * FROM HISTORY_ORDERS;
BEGIN
    OPEN history_orders_curs;
    FETCH history_orders_curs INTO History;
    WHILE history_orders_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(History.ID_HISTORY_ORDER || ' ' || History.ORDERID || ' ' || History.CREATEAT || ' ' || History.CUSTOMERID || ' ' || History.OPERATION);
        FETCH history_orders_curs INTO History;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

--Обновление статуса заказа--
CREATE OR REPLACE PROCEDURE UpdateStatusOrder (OrderId ORDERS.ID_ORDER%TYPE, NewStatus ORDERS.STATUS_ID%type)
IS
    Order_ ORDERS%rowtype;
BEGIN
    SELECT * INTO Order_ FROM ORDERS WHERE ID_ORDER=OrderId;
    UPDATE ORDERS Set STATUS_ID = NewStatus where ORDERS.ID_ORDER = OrderId;
    DBMS_OUTPUT.PUT_LINE('Статус успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Заказа не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

----------------------------Products------------
--Добавление товара--
CREATE OR REPLACE PROCEDURE AddProduct
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
    ELSE
        DBMS_OUTPUT.PUT_LINE('Данные неактивны');
    END IF;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Удаление товара--
CREATE OR REPLACE PROCEDURE DeleteProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE)
IS
    Prod PRODUCTS%ROWTYPE;
BEGIN
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=IdProduct;
    UPDATE PRODUCTS SET CANORDER=0 WHERE ID_PRODUCT=IdProduct;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Товара с таким Id не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

    --Изменение информации о товаре--
CREATE OR REPLACE PROCEDURE UpdateProduct(IdProduct PRODUCTS.ID_PRODUCT%TYPE,ProdPrice PRODUCTS.PRICE%TYPE,ProdCount PRODUCTS.COUNT_OF_PRODUCTS%TYPE, ProdSName PRODUCTS.SHORT_NAME%TYPE, ProdDesc PRODUCTS.DESCRIPTION%TYPE,ProdCat PRODUCTS.CATEGORY_ID%TYPE,ProdName PRODUCTS.PRODUCT_NAME%TYPE)
IS
BEGIN
        UPDATE PRODUCTS SET PRICE = ProdPrice, COUNT_OF_PRODUCTS=ProdCount, SHORT_NAME=ProdSName, DESCRIPTION=ProdDesc,CATEGORY_ID=ProdCat,PRODUCT_NAME=ProdName WHERE ID_PRODUCT=IdProduct;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Изменение цены товара--
CREATE OR REPLACE PROCEDURE UpdateProduct(ProdId PRODUCTS.ID_PRODUCT%TYPE, PriceProd PRODUCTS.PRICE%TYPE)
IS
    Prod_Id PRODUCTS.ID_PRODUCT%TYPE;
BEGIN
    SELECT ID_PRODUCT INTO Prod_Id FROM PRODUCTS WHERE ID_PRODUCT =ProdId;
	Update PRODUCTS Set PRICE = PriceProd Where ID_PRODUCT =ProdId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Товара с таким Id не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Получение всех товаров--
CREATE OR REPLACE PROCEDURE GetAllProducts
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
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;


----------------------------ProductCategory------------
--Добавление категории--
CREATE OR REPLACE PROCEDURE AddCategory
    (
    CategoryName PRODUCTCATEGORY.CATEGORY_NAME%TYPE
    )
IS
BEGIN
    INSERT INTO PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    VALUES (CategoryName,1);
  --COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Удаление категории--
CREATE OR REPLACE PROCEDURE DeleteCategory(IdCategory PRODUCTCATEGORY.ID_CATEGORY%TYPE)
IS
    IDCat PRODUCTCATEGORY%ROWTYPE;
BEGIN
    SELECT * INTO IDCat FROM PRODUCTCATEGORY WHERE ID_CATEGORY=IdCategory;
    update PRODUCTCATEGORY set ACTIVE=0 where ID_CATEGORY=IdCategory;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Категории с таким Id не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;


--Изменение категории--
CREATE OR REPLACE PROCEDURE UpdateCategory(CatId PRODUCTCATEGORY.ID_CATEGORY%TYPE, NameCat PRODUCTCATEGORY.CATEGORY_NAME%TYPE)
IS
    Prod_Cat_Id PRODUCTS.ID_PRODUCT%TYPE;
BEGIN
    SELECT ID_CATEGORY INTO Prod_Cat_Id FROM PRODUCTCATEGORY WHERE ID_CATEGORY =CatId;
	Update PRODUCTCATEGORY Set CATEGORY_NAME = NameCat Where ID_CATEGORY =CatId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Такой категории не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Получение всех категорий--
CREATE OR REPLACE PROCEDURE GetAllCategory
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
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID) values('карандаш',25,5,'кар','гуд карандаш',2);
insert into PRODUCTCATEGORY(CATEGORY_NAME) values ('канцелярия');
commit;


--------------------------------------Cart--------------------------
--Добавление в корзину--
CREATE OR REPLACE PROCEDURE AddToCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE,IdProduct PRODUCTS.ID_PRODUCT%TYPE)
IS
    Prod PRODUCTS%ROWTYPE;
    Cust CUSTOMERS%ROWTYPE;
    ProdId CART.PRODUCTID%TYPE;
    CustId CART.ID_CUSTOMER%TYPE;
BEGIN
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=IdProduct;
    SELECT * INTO Cust FROM CUSTOMERS WHERE ID_CUSTOMER=IdCustomer;
    IF(Prod.CANORDER=1 AND Cust.ACTIVE=1) THEN
    INSERT INTO CART(ID_CUSTOMER,PRODUCTID) values (IdCustomer,IdProduct);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Данные неактивны');
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данного товара или пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Просмотр корзины--
CREATE OR REPLACE PROCEDURE GetProductsInCart(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
    AllProducts CART%rowtype;
    CURSOR get_product_curs IS SELECT * FROM CART where ID_CUSTOMER = IdCustomer;
BEGIN
    OPEN get_product_curs;
    FETCH get_product_curs INTO AllProducts;
    WHILE get_product_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE(AllProducts.ID_CART || ' ' || AllProducts.ID_CUSTOMER || ' ' || AllProducts.PRODUCTID) ;
        FETCH get_product_curs INTO AllProducts;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

--Изменение товара в корзине--
CREATE OR REPLACE PROCEDURE UpdateProdInCart(CartId CART.ID_CART%TYPE, ProdId CART.PRODUCTID%TYPE)
IS
    Cart_Id CART.ID_CART%TYPE;
BEGIN
    SELECT ID_CART INTO Cart_Id FROM CART WHERE ID_CART=CartId;
	Update CART Set PRODUCTID = ProdId Where ID_CART=CartId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данного товара в корзине нет');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Удаление товара из корзины--
CREATE OR REPLACE PROCEDURE DeleteProdFromCart(IdProduct CART.PRODUCTID%TYPE, IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
  --  Cart_ CART%ROWTYPE;
BEGIN
  --  SELECT * INTO Cart_ FROM CART WHERE PRODUCTID=IdProduct;
    DELETE FROM CART WHERE ID_CUSTOMER=IdCustomer and PRODUCTID=IdProduct;
        EXCEPTION
  --   WHEN NO_DATA_FOUND THEN
   --      DBMS_OUTPUT.PUT_LINE('Данного товара в корзине нет');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;




----------------------------------------Suppliers-----------------------------
--Добавление поставщика--
CREATE OR REPLACE PROCEDURE AddSupplier
    (
    SupplierName SUPPLIERS.NAME_SUPPLIER%TYPE,
    EmailSupp SUPPLIERS.EMAIL%TYPE,
    NumberPhone SUPPLIERS.PHONE_NUMBER%TYPE,
    IdCity SUPPLIERS.CITY_ID%TYPE
    )
IS
BEGIN
    INSERT INTO SUPPLIERS(NAME_SUPPLIER,EMAIL,PHONE_NUMBER,CITY_ID,ACTIVE)
    VALUES (SupplierName,EmailSupp,NumberPhone,IdCity,1);
  --COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Удаление поставщика-- ПРОВЕРИТЬ
CREATE OR REPLACE PROCEDURE DeleteSupplier(IdSupplier SUPPLIERS.ID_SUPPLIER%TYPE)
IS
    Supp SUPPLIERS%ROWTYPE;
BEGIN
    SELECT * INTO Supp FROM SUPPLIERS WHERE ID_SUPPLIER=IdSupplier;
    UPDATE SUPPLIERS SET ACTIVE=0 WHERE ID_SUPPLIER=IdSupplier;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Такого поставщика не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;


------------------------------------------Status-------------------------------------
--Добавление статуса--
CREATE OR REPLACE PROCEDURE AddStatus
    (
    StatusName STATUS.STATUS_NAME%TYPE
    )
IS
BEGIN
    INSERT INTO STATUS(STATUS_NAME)
    VALUES (StatusName);
  --COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Просмотр всех статусов--
CREATE OR REPLACE PROCEDURE GetAllStatus
IS
    AllStatus STATUS%rowtype;
    CURSOR get_status_curs IS SELECT * FROM STATUS;
BEGIN
    OPEN get_status_curs;
    FETCH get_status_curs INTO AllStatus;
    WHILE get_status_curs%FOUND
        LOOP
        DBMS_OUTPUT.PUT_LINE('IdStatus:'||' '||AllStatus.ID_STATUS|| ' ' ||'StatusName:'||' '|| AllStatus.STATUS_NAME);
        FETCH get_status_curs INTO AllStatus;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
 END;

    -----------------------------PaymentMethod----------------
    --Добавление метода оплаты--
CREATE OR REPLACE PROCEDURE AddPayMethod
    (
    PayMethodName PAYMENTMETHOD.PAYMENTMETHOD_NAME%TYPE
    )
IS
BEGIN
    INSERT INTO PAYMENTMETHOD(PAYMENTMETHOD_NAME)
    VALUES (PayMethodName);
    COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

    --Просмотр методов оплаты--
CREATE OR REPLACE PROCEDURE GetAllPayMethod
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
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
 END;




        -----------------------------DeliveryMethod----------------
    --Добавление метода доставки--
CREATE OR REPLACE PROCEDURE AddDeliveryMethod
    (
    DeliveryMethodName DELIVERYMETHOD.DELIVERY_METHOD%TYPE,
    DeliveryMethodPrice DELIVERYMETHOD.DELIVERY_PRICE%TYPE
    )
IS
BEGIN
    INSERT INTO DELIVERYMETHOD(DELIVERY_METHOD,DELIVERY_PRICE)
    VALUES (DeliveryMethodName,DeliveryMethodPrice);
    COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Просмотр методов доставки--
CREATE OR REPLACE PROCEDURE GetAllDeliveryMethod
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
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
 END;

----------------------------OrderDetails-----------------------
--Добавление--
CREATE OR REPLACE PROCEDURE AddOrderDetails(OrderId ORDER_DETAILS.ORDER_ID%TYPE,CountProd ORDER_DETAILS.COUNT_OF_PRODUCT%TYPE,ProdId ORDER_DETAILS.PRODUCT_ID%TYPE)
IS
    Prod PRODUCTS%ROWTYPE;
    Ord ORDERS%ROWTYPE;
BEGIN
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=ProdId;
    SELECT * INTO Ord FROM ORDERS WHERE ID_ORDER=OrderId;
    IF(Prod.CANORDER=1 AND Ord.STATUS_ID!=5) THEN
    INSERT INTO ORDER_DETAILS(ORDER_ID,COUNT_OF_PRODUCT,PRODUCT_ID,ACTIVE) values (OrderId,CountProd,ProdId,1);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Данные неактивны');
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данных не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

        --Удаление--
CREATE OR REPLACE PROCEDURE DeleteOrderDetails(IdOrderDet ORDER_DETAILS.ID_ORDER_DETAILS%TYPE)
IS
BEGIN
    UPDATE ORDER_DETAILS SET ACTIVE=0 WHERE ID_ORDER_DETAILS=IdOrderDet;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данных не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;



------------------------------------CUSTOMERS------------------------
--Добавление покупателя--
CREATE OR REPLACE PROCEDURE AddCustomer(
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
        DBMS_OUTPUT.PUT_LINE('Данные неактивны');
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данного пользователя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Удаление покупателя--
CREATE OR REPLACE PROCEDURE DeleteCustomers(idCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
is
 Usr USERS%ROWTYPE;
BEGIN
    UPDATE CUSTOMERS SET ACTIVE=0 WHERE ID_CUSTOMER=idCustomer;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Данных не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
END;

--Получить информацию о покупателе--
CREATE OR REPLACE PROCEDURE ShowInfoСustomer(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
IS
    Cust CUSTOMERS%ROWTYPE;
BEGIN
    SELECT * INTO Cust FROM CUSTOMERS WHERE ID_CUSTOMER=IdCustomer;
    DBMS_OUTPUT.PUT_LINE('IdCustomer:'||' '||Cust.ID_CUSTOMER||' '||'FirstName:'||' '||Cust.FIRST_NAME||' '||'MiddleName:'||' '||Cust.MIDDLE_NAME||' '||'LastName:'||' '||Cust.LAST_NAME||' '||'Gender:'||' '||Cust.GENDER||' '||'PhoneNumber:'||' '||Cust.PHONE_NUMBER||' '||'Email:'||' '||Cust.EMAIL||' '||'UserId:'||' '||Cust.USER_ID);
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Такого покупателя не существует');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
end;

--Получить информацию о всех покупателях--
CREATE OR REPLACE PROCEDURE GetAllCustomers
IS
    CustInfo CUSTOMERS%rowtype;
    CURSOR custom_curs IS SELECT * FROM CUSTOMERS;
BEGIN
    OPEN custom_curs;
    FETCH custom_curs INTO CustInfo;
    WHILE custom_curs%FOUND
        LOOP
      DBMS_OUTPUT.PUT_LINE('IdCustomer:'||' '||CustInfo.ID_CUSTOMER||' '||'FirstName:'||' '||CustInfo.FIRST_NAME||' '||'MiddleName:'||' '||CustInfo.MIDDLE_NAME||' '||'LastName:'||' '||CustInfo.LAST_NAME||' '||'Gender:'||' '||CustInfo.GENDER||' '||'PhoneNumber:'||' '||CustInfo.PHONE_NUMBER||' '||'Email:'||' '||CustInfo.EMAIL||' '||'UserId:'||' '||CustInfo.USER_ID);
       FETCH custom_curs INTO CustInfo;
        END LOOP;
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;

--История заказов покупателя--
CREATE OR REPLACE PROCEDURE GetHistoryOrderedCustomer(IdCust History_orders.CUSTOMERID%type)
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
EXCEPTION
     WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('error: '||sqlerrm||' , code: '||sqlcode);
 --rollback;
end;
