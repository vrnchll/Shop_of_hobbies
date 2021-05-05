--package_admin_Suppliers--
CREATE OR REPLACE PACKAGE package_admin_Suppliers
IS
   PROCEDURE AddSupplier
    (
    SupplierName SUPPLIERS.NAME_SUPPLIER%TYPE,
    EmailSupp SUPPLIERS.EMAIL%TYPE,
    NumberPhone SUPPLIERS.PHONE_NUMBER%TYPE,
    IdCity SUPPLIERS.CITY_ID%TYPE
    );
  PROCEDURE DeleteSupplier(IdSupplier SUPPLIERS.ID_SUPPLIER%TYPE);
END package_admin_Suppliers;


CREATE OR REPLACE PACKAGE BODY package_admin_Suppliers
AS
--Добавление поставщика--
PROCEDURE AddSupplier
    (
    SupplierName SUPPLIERS.NAME_SUPPLIER%TYPE,
    EmailSupp SUPPLIERS.EMAIL%TYPE,
    NumberPhone SUPPLIERS.PHONE_NUMBER%TYPE,
    IdCity SUPPLIERS.CITY_ID%TYPE
    )
IS
    CityId SUPPLIERS.CITY_ID%TYPE;
BEGIN
    select ID_CITY into CityId from CITIES where ID_CITY=IdCity;
    INSERT INTO SUPPLIERS(NAME_SUPPLIER,EMAIL,PHONE_NUMBER,CITY_ID,ACTIVE)
    VALUES (SupplierName,EmailSupp,NumberPhone,IdCity,1);
    COMMIT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Неверный город');
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddSupplier;

--Удаление поставщика--
PROCEDURE DeleteSupplier(IdSupplier SUPPLIERS.ID_SUPPLIER%TYPE)
IS
    Supp SUPPLIERS%ROWTYPE;
BEGIN
    SELECT * INTO Supp FROM SUPPLIERS WHERE ID_SUPPLIER=IdSupplier;
    UPDATE SUPPLIERS SET ACTIVE=0 WHERE ID_SUPPLIER=IdSupplier;
     commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Такого поставщика не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteSupplier;
    END package_admin_Suppliers;