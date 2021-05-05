--package_admin_customer--
CREATE OR REPLACE PACKAGE package_admin_customer
IS
   PROCEDURE AddCustomer(CustFirstName CUSTOMERS.FIRST_NAME%TYPE,CustMiddleName CUSTOMERS.MIDDLE_NAME%TYPE,CustLastName CUSTOMERS.LAST_NAME%TYPE,CustGenger CUSTOMERS.GENDER%TYPE,CustPhoneNumb CUSTOMERS.PHONE_NUMBER%TYPE,CustEmail CUSTOMERS.EMAIL%TYPE,CustUserId CUSTOMERS.USER_ID%TYPE);
   PROCEDURE DeleteCustomers(idCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
   PROCEDURE ShowInfoСustomer(IdCustomer CUSTOMERS.ID_CUSTOMER%TYPE);
   PROCEDURE GetAllCustomers;
   PROCEDURE GetHistoryOrderedCustomer(IdCust History_orders.CUSTOMERID%type);

       END package_admin_customer;

CREATE OR REPLACE PACKAGE BODY package_admin_customer
is
 --Добавление покупателя--
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
    commit;
    ELSE
        raise_application_error(-20201,'Данные неактивны');
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данного пользователя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END AddCustomer;

--Удаление покупателя--
PROCEDURE DeleteCustomers(idCustomer CUSTOMERS.ID_CUSTOMER%TYPE)
is
 cust CUSTOMERS%ROWTYPE;
BEGIN
    SELECT * INTO cust FROM CUSTOMERS WHERE ID_CUSTOMER=idCustomer;
    UPDATE CUSTOMERS SET ACTIVE=0 WHERE ID_CUSTOMER=idCustomer;
    commit;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Данных не существует');
     WHEN OTHERS THEN
         raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteCustomers;

--Получить информацию о покупателе--
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

--Получить информацию о всех покупателях--
PROCEDURE GetAllCustomers
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
    close custom_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetAllCustomers;

--История заказов покупателя--
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

    end package_admin_customer;