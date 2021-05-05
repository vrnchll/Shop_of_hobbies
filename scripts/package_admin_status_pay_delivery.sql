--package_admin_status_pay_delivery--
CREATE OR REPLACE PACKAGE package_admin_status_pay_delivery
IS
    --status--
    PROCEDURE AddStatus(StatusName STATUS.STATUS_NAME%TYPE);
    PROCEDURE GetAllStatus;
    --paymentMethod--
    PROCEDURE AddPayMethod(PayMethodName PAYMENTMETHOD.PAYMENTMETHOD_NAME%TYPE);
    PROCEDURE GetAllPayMethod;
    --deliveryMethod--
    PROCEDURE AddDeliveryMethod(DeliveryMethodName DELIVERYMETHOD.DELIVERY_METHOD%TYPE,DeliveryMethodPrice DELIVERYMETHOD.DELIVERY_PRICE%TYPE);
    PROCEDURE GetAllDeliveryMethod;
END package_admin_status_pay_delivery;

CREATE OR REPLACE PACKAGE BODY package_admin_status_pay_delivery
is
 ------------------------------------------Status-------------------------------------
--Добавление статуса--
PROCEDURE AddStatus
    (
    StatusName STATUS.STATUS_NAME%TYPE
    )
IS
BEGIN
    INSERT INTO STATUS(STATUS_NAME)
    VALUES (StatusName);
    COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddStatus;

--Просмотр всех статусов--
PROCEDURE GetAllStatus
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
    close get_status_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
 END GetAllStatus;

    -----------------------------PaymentMethod----------------
    --Добавление метода оплаты--
PROCEDURE AddPayMethod
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
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddPayMethod;

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
 END GetAllPayMethod;

        -----------------------------DeliveryMethod----------------
    --Добавление метода доставки--
PROCEDURE AddDeliveryMethod
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
    raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddDeliveryMethod;

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

    end package_admin_status_pay_delivery;