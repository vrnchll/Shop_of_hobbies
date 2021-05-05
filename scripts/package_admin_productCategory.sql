--package_admin_productCategory--
CREATE OR REPLACE PACKAGE package_admin_productCategory
IS
   PROCEDURE AddCategory (CategoryName PRODUCTCATEGORY.CATEGORY_NAME%TYPE);
   PROCEDURE DeleteCategory(IdCategory PRODUCTCATEGORY.ID_CATEGORY%TYPE);
   PROCEDURE UpdateCategory(CatId PRODUCTCATEGORY.ID_CATEGORY%TYPE, NameCat PRODUCTCATEGORY.CATEGORY_NAME%TYPE);
   PROCEDURE GetAllCategory;
END package_admin_productCategory;


CREATE OR REPLACE PACKAGE BODY package_admin_productCategory
AS
--Добавление категории--
PROCEDURE AddCategory
    (
    CategoryName PRODUCTCATEGORY.CATEGORY_NAME%TYPE
    )
IS
BEGIN
    INSERT INTO PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    VALUES (CategoryName,1);
    commit;
  --COMMIT;
    EXCEPTION
     WHEN OTHERS THEN
      raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end AddCategory;
--------------------------------
--Удаление категории--
PROCEDURE DeleteCategory(IdCategory PRODUCTCATEGORY.ID_CATEGORY%TYPE)
IS
    IDCat PRODUCTCATEGORY%ROWTYPE;
BEGIN
    SELECT * INTO IDCat FROM PRODUCTCATEGORY WHERE ID_CATEGORY=IdCategory;
    update PRODUCTCATEGORY set ACTIVE=0 where ID_CATEGORY=IdCategory;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Категории с таким Id не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteCategory;

------------------------------
--Изменение категории--
PROCEDURE UpdateCategory(CatId PRODUCTCATEGORY.ID_CATEGORY%TYPE, NameCat PRODUCTCATEGORY.CATEGORY_NAME%TYPE)
IS
    Prod_Cat_Id PRODUCTS.ID_PRODUCT%TYPE;
BEGIN
    SELECT ID_CATEGORY INTO Prod_Cat_Id FROM PRODUCTCATEGORY WHERE ID_CATEGORY =CatId;
	Update PRODUCTCATEGORY Set CATEGORY_NAME = NameCat Where ID_CATEGORY =CatId;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
          raise_application_error(-20000,'Такой категории не существует');
     WHEN OTHERS THEN
         raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END UpdateCategory;
-------------------------------------
--Получение всех категорий--
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

    END package_admin_productCategory;