--insert into users
declare
    i number:=0;
  begin loop
    i:=i+1;
    insert into USERS(TYPE_OF_USER,LOGIN,PASSWORD,ACTIVE) values ('USER','veronika'||''||i,'my_pass_vrn'||''||i,1);
    exit when (i>=11000);
  end loop;
end;
select count(ID_USER) from users;
select *
from USERS;

-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Ника','Серге','Бобрик','ж',7967757,'vrn@mail.ru',1,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Иван','Иван','Иванов','м',6325598,'ivan@mail.ru',1059,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Максим','Серге','Лопух','м',7775544,'aleks@mail.ru',1055,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Сергей','Михай','Бобрик','м',8883608,'serega@mail.ru',999,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Настя','Серге','Хован','ж',2237733,'nastya@mail.ru',589,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Галина','Валер','Пунько','ж',2026014,'geil@mail.ru',578,1);
-- insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE)
-- values ('Вадим','Максим','Минаков','м',5411083,'vadik@mail.ru',777,1);

--insert into customers
declare
    i number:=0;
    idUser USERS.ID_USER%type;
  begin loop
    select min(ID_USER) into idUser from USERS;
    i:=i+1;
    insert into CUSTOMERS(FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,PHONE_NUMBER,EMAIL,USER_ID,ACTIVE) values ('Вадим'||''||i,'Макс'||''||i,'Минкв'||''||i,'м',23548||''||i,'vadik'||''||i||'@mail.ru',idUser+i+7,1);
    exit when (i>=20000);
  end loop;
end;

select * from CUSTOMERS;
select count(*) from CUSTOMERS;
---------------------------------------------------------------------------
--insert into suppliers--
declare
    i number:=0;
    idCity CITIES.ID_CITY%type;
  begin loop
    select min(ID_USER) into idCity from USERS;
    i:=i+1;
    insert into SUPPLIERS(NAME_SUPPLIER,EMAIL,PHONE_NUMBER,CITY_ID,ACTIVE)
    values ('3кота'||'_'||i,'cat'||'_'||i||'@mail.ru',33587||''||i,idCity+i+7,1);
    exit when (i>=3000);
  end loop;
  begin loop
    select min(ID_USER) into idCity from USERS;
    i:=i+1;
    insert into SUPPLIERS(NAME_SUPPLIER,EMAIL,PHONE_NUMBER,CITY_ID,ACTIVE)
    values ('Гали'||'_'||i,'gali'||'_'||i||'@mail.ru',87569||''||i,idCity+i+50,1);
    exit when (i>=6000);
  end loop;
  end;
  begin loop
    select min(ID_USER) into idCity from USERS;
    i:=i+1;
    insert into SUPPLIERS(NAME_SUPPLIER,EMAIL,PHONE_NUMBER,CITY_ID,ACTIVE)
    values ('Лео'||'_'||i,'leo'||'_'||i||'@mail.ru',788756||''||i,idCity+i+12,1);
    exit when (i>=5000);
  end loop;
  end;
end;

select * from SUPPLIERS;
select count(*) from SUPPLIERS;

------------------------------------------------
--insert into productCategory--
  begin
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Краски',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Клеев.матер.',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Бумага',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Канцтовары',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Инструменты',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Заготовки',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Скетчинг',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Холсты',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Глина',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Декупаж',1);
    insert into PRODUCTCATEGORY(CATEGORY_NAME,ACTIVE)
    values ('Скрапбукинг',1);
end;

select * from PRODUCTCATEGORY;

--------------------------------------------------------------------
--insert into products--
declare
    i number:=0;
  begin
  loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Клей'||''||i,2+i,10+i,'кл'||''||i,'ПВА',2,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Скотч'||''||i,1+i,5+i,'ск'||''||i,'Двусторонний',2,1);
    exit when (i>=500);
  end loop;
 begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Акварель'||''||i,5+i,10+i,'акв'||''||i,'Водоустойчивые',1,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Гуашь'||''||i,3+i,5+i,'гуа'||''||i,'Стойкая',1,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Масляная'||''||i,6+i,10+i,'мас'||''||i,'Быстро сохнет',1,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Акриловая'||''||i,5+i,11+i,'акр'||''||i,'Быстро сохнет',1,1);
    exit when (i>=300);
  end loop;
 end;
    begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Бумага'||''||i,3+i,20+i,'бу'||''||i,'Тонкая',3,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Картон'||''||i,4+i,20+i,'кар'||''||i,'Двусторонний',3,1);
     insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Калька'||''||i,2+i,10+i,'ка'||''||i,'Прочнвя',3,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Квиллинг'||''||i,1+i,5+i,'кв'||''||i,'Толстый',3,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Гафрированная'||''||i,1+i,5+i,'га'||''||i,'Длинная',3,1);
    exit when (i>=1000);
  end loop;
end;
        begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Карандаш'||''||i,1,20+i,'ка'||''||i,'M',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ручка'||''||i,1,20+i,'ру'||''||i,'Синия',4,1);
     insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ластик'||''||i,1,10+i,'ла'||''||i,'Белый',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Линейка'||''||i,1,5+i,'ли'||''||i,'15',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Точилка'||''||i,1,5+i,'то'||''||i,'Маленькая',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Маркер'||''||i,2,5+i,'ма'||''||i,'Черный',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Фломастер'||''||i,2,5+i,'фл'||''||i,'Один',4,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Корректор'||''||i,2,5+i,'ко'||''||i,'Белый',4,1);
    exit when (i>=500);
  end loop;
end;
 begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ножницы'||''||i,2,7+i,'ка'||''||i,'Острые',5,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ножик'||''||i,3,7+i,'ру'||''||i,'Канцелярский',5,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ролик'||''||i,6,7+i,'ка'||''||i,'Пластик',5,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Молд'||''||i,6,7+i,'ру'||''||i,'Балерина',5,1);
    exit when (i>=700);
  end loop;
    end;
     begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Заяц'||''||i,5,7+i,'за'||''||i,'Дерево',6,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Абриков'||''||i,5,7+i,'аб'||''||i,'Дерево',6,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Танк'||''||i,6,7+i,'та'||''||i,'Дерево',6,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Елка'||''||i,6,7+i,'ел'||''||i,'Дерево',6,1);
    exit when (i>=1000);
  end loop;
end;
begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Ручки'||''||i,4,7+i,'ру'||''||i,'Набор',7,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Альбом'||''||i,10,7+i,'ал'||''||i,'Бумажный',7,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Пенал'||''||i,6,7+i,'пе'||''||i,'Пластик',7,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Бумага'||''||i,2,7+i,'ел'||''||i,'Черная',7,1);
    exit when (i>=2000);
  end loop;
end;
    begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Мольберт'||''||i,50,7+i,'мо'||''||i,'Дерево',8,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Холст'||''||i,30,7+i,'ал'||''||i,'Грунт',8,1);
    exit when (i>=1000);
  end loop;
end;
begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Молд'||''||i,10,7+i,'мо'||''||i,'Глина',9,1);
    exit when (i>=2000);
  end loop;
end;
begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Лак'||''||i,6,7+i,'ла'||''||i,'Акриловый',10,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Клей'||''||i,2,7+i,'кл'||''||i,'Декупажный',10,1);
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Заготовка'||''||i,4,7+i,'за'||''||i,'Дерево',10,1);
    exit when (i>=2000);
  end loop;
end;
    begin loop
    i:=i+1;
    insert into PRODUCTS(PRODUCT_NAME,PRICE,COUNT_OF_PRODUCTS,SHORT_NAME,DESCRIPTION,CATEGORY_ID,CANORDER)
    values ('Салфетка'||''||i,3,7+i,'са'||''||i,'33х33',11,1);
    exit when (i>=4000);
  end loop;
end;
  end;

select count(*) from PRODUCTS;
select * from PRODUCTS;

------------------------------------------------------
--insert into prod_supp
declare
    i number:=0;
    MinidProd PRODUCTS.ID_PRODUCT%type;
    MaxIdProd PRODUCTS.ID_PRODUCT%type;
    MinidSup SUPPLIERS.ID_SUPPLIER%type;
    MaxIdSup SUPPLIERS.ID_SUPPLIER%type;
  begin loop
    select min(ID_PRODUCT) into MinidProd from PRODUCTS;
    select max(ID_PRODUCT) into MaxIdProd from PRODUCTS;
    select min(ID_SUPPLIER) into MinidSup from SUPPLIERS;
    select max(ID_SUPPLIER) into MaxIdSup from SUPPLIERS;
    i:=i+1;
    insert into PRODUCTS_SUPPLIERS(PRODUCTS_ID,SUPPLIERS_ID)
    values (MinidProd+i+2,MaxIdSup-i-1);
    insert into PRODUCTS_SUPPLIERS(PRODUCTS_ID,SUPPLIERS_ID)
    values (MaxIdProd-i-2,MinidSup+i);
    insert into PRODUCTS_SUPPLIERS(PRODUCTS_ID,SUPPLIERS_ID)
    values (MinidProd+i+2,MinidSup+i+8);
    insert into PRODUCTS_SUPPLIERS(PRODUCTS_ID,SUPPLIERS_ID)
    values (MaxIdProd-i,MaxIdSup-i);
    exit when (i>=500);
  end loop;
end;

select count(*)
from PRODUCTS_SUPPLIERS;
select * from SUPPLIERS;
select * from PRODUCTS;



-----------------------------------------------------
----------------insert into Status--------------------
insert into status values (3,'оформлен');
insert into status values (4,'выполнен');
insert into status values (5,'отменен');

select * from status;

-----------------------------------------------------
----------------insert into paymentMethod--------------------
insert into PAYMENTMETHOD values (1,'карта');
insert into PAYMENTMETHOD values (2,'нал');

select * from PAYMENTMETHOD;

-----------------------------------------------------
----------------insert into deliveryMethod--------------------
insert into DELIVERYMETHOD values (1,'почта',5);
insert into DELIVERYMETHOD values (2,'дост',10);
insert into DELIVERYMETHOD values (3,'сам-выв',0);

select * from DELIVERYMETHOD;

------------------------------------------------------
--insert into cart
declare
    i NUMBER:=0;
    MinIdCust CUSTOMERS.ID_CUSTOMER%type;
    MinIdProd PRODUCTS.ID_PRODUCT%type;
  begin loop
    select min(ID_PRODUCT) into MinIdProd from PRODUCTS;
    select min(ID_CUSTOMER) into MinIdCust from CUSTOMERS;
    i:=i+1;
    insert into CART(CUSTOMER_ID,PRODUCT_ID)
    values (MinIdCust,MinIdProd+i+11);
    exit when (i>=2000);
  end loop;
end;
--
select count(*) from cart;
select * from CUSTOMERS;
---------------------------------------
------------------insert into orders------------
--insert into prod_supp
declare
    i number:=0;
    MinidCust CUSTOMERS.ID_CUSTOMER%type;
    MinidCity CITIES.ID_CITY%type;
  begin loop
    select min(ID_CUSTOMER) into MinidCust from CUSTOMERS;
    select min(ID_CITY) into MinidCity from CITIES;
    i:=i+1;
    insert into ORDERS(CUSTOMER_ID,DELIVERYMETHOD_ID,PAYMENTMETHOD_ID,ADDRESS,CITY_ID,STATUS_ID)
    values (MinidCust+i+2,1,1,'Зои К. 2'||''||i,MinidCity+i+13,3);
    exit when (i>=100000);
  end loop;
end;

select count(*) from orders;


------------------------------------------------
-----------insert into order_details
declare
    i number:=0;
    MinidOrder ORDERS.ID_ORDER%type;
    MinidProduct PRODUCTS.ID_PRODUCT%type;
  begin loop
    select min(ID_ORDER) into MinidOrder from ORDERS;
    select min(ID_PRODUCT) into MinidProduct from PRODUCTS;
    i:=i+1;
    insert into ORDER_DETAILS(ORDER_ID,COUNT_OF_PRODUCT,PRODUCT_ID,ACTIVE)
    values (MinidOrder+i,1+i,MinidProduct+i,1);
    exit when (i>=1000);
  end loop;
end;

select count(*) from order_details;
select count(*) from CITIES;
select count(*) from CUSTOMERS;
select count(*) from DELIVERYMETHOD;
select count(*) from HISTORY_ORDERS;
select count(*) from HISTORY_USER_ACTION;
select count(*) from ORDERS;
select count(*) from PAYMENTMETHOD;
select count(*) from PRODUCTCATEGORY;
select count(*) from PRODUCTS;
select count(*) from PRODUCTS_SUPPLIERS;
select count(*) from STATUS;
select count(*) from SUPPLIERS;
select count(*) from USERS;