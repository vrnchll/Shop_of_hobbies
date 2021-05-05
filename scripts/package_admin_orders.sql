--package_admin_orders--
CREATE OR REPLACE PACKAGE package_admin_orders
IS
   PROCEDURE AddOrder(CustomerId ORDERS.CUSTOMER_ID%TYPE,DeliveryId ORDERS.DELIVERYMETHOD_ID%TYPE,PaymentId ORDERS.PAYMENTMETHOD_ID%TYPE,Address ORDERS.ADDRESS%TYPE,CityId ORDERS.CITY_ID%TYPE);
   PROCEDURE RepealOrder (IdOrder ORDERS.ID_ORDER%TYPE);
   PROCEDURE GetHistoryOrdered;
   PROCEDURE UpdateStatusOrder (OrderId ORDERS.ID_ORDER%TYPE, NewStatus ORDERS.STATUS_ID%type);
END package_admin_orders;


CREATE OR REPLACE PACKAGE BODY package_admin_orders
AS
--Добавление заказа
PROCEDURE AddOrder
(
CustomerId ORDERS.CUSTOMER_ID%TYPE,
DeliveryId ORDERS.DELIVERYMETHOD_ID%TYPE,
PaymentId ORDERS.PAYMENTMETHOD_ID%TYPE,
Address ORDERS.ADDRESS%TYPE,
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
VALUES (CustomerId,DeliveryId,PaymentId,Address,CityId,3);
commit;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Введены несуществующие данные');
    WHEN OTHERS THEN
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddOrder;
---------------------------------------
------------------Отмена заказа--------
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
------------------------------------
------------История заказов---------
PROCEDURE GetHistoryOrdered
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
    close history_orders_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetHistoryOrdered;

--------------------------------------
-------Обновление статуса заказа------
PROCEDURE UpdateStatusOrder (OrderId ORDERS.ID_ORDER%TYPE, NewStatus ORDERS.STATUS_ID%type)
IS
    Order_ ORDERS%rowtype;
BEGIN
    SELECT * INTO Order_ FROM ORDERS WHERE ID_ORDER=OrderId;
    UPDATE ORDERS Set STATUS_ID = NewStatus where ORDERS.ID_ORDER = OrderId;
    commit;
    DBMS_OUTPUT.PUT_LINE('Статус успешно изменен');
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Заказа не существует');
     WHEN OTHERS THEN
       raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdateStatusOrder;

    END package_admin_orders;