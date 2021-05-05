--package_admin_orderDetails--
CREATE OR REPLACE PACKAGE package_admin_orderDetails
IS
    PROCEDURE AddOrderDetails(OrderId ORDER_DETAILS.ORDER_ID%TYPE,CountProd ORDER_DETAILS.COUNT_OF_PRODUCT%TYPE,ProdId ORDER_DETAILS.PRODUCT_ID%TYPE);
    PROCEDURE DeleteOrderDetails(IdOrderDet ORDER_DETAILS.ID_ORDER_DETAILS%TYPE);
END package_admin_orderDetails;

CREATE OR REPLACE PACKAGE BODY package_admin_orderDetails
is
--Добавление--
PROCEDURE AddOrderDetails(OrderId ORDER_DETAILS.ORDER_ID%TYPE,CountProd ORDER_DETAILS.COUNT_OF_PRODUCT%TYPE,ProdId ORDER_DETAILS.PRODUCT_ID%TYPE)
IS
    Prod PRODUCTS%ROWTYPE;
    Ord ORDERS%ROWTYPE;
BEGIN
    SELECT * INTO Prod FROM PRODUCTS WHERE ID_PRODUCT=ProdId;
    SELECT * INTO Ord FROM ORDERS WHERE ID_ORDER=OrderId;
    IF(Prod.CANORDER=1 AND Ord.STATUS_ID!=5) THEN
    INSERT INTO ORDER_DETAILS(ORDER_ID,COUNT_OF_PRODUCT,PRODUCT_ID,ACTIVE) values (OrderId,CountProd,ProdId,1);
    commit;
    ELSE
        raise_application_error(-20201,'Данные неактивны');
    END IF;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Данных не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END AddOrderDetails;

--Удаление--
PROCEDURE DeleteOrderDetails(IdOrderDet ORDER_DETAILS.ID_ORDER_DETAILS%TYPE)
IS
BEGIN
    UPDATE ORDER_DETAILS SET ACTIVE=0 WHERE ID_ORDER_DETAILS=IdOrderDet;
    commit;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Данных не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteOrderDetails;
    end package_admin_orderDetails;