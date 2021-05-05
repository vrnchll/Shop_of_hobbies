--package_admin_user--
CREATE OR REPLACE PACKAGE package_admin_user
IS
   PROCEDURE Register_user_admin(UserName USERS.LOGIN%TYPE,PasswordUser USERS.PASSWORD%TYPE);
   PROCEDURE LoginUser (LoginUser USERS.LOGIN%TYPE, PasswordUser USERS.PASSWORD%TYPE);
   PROCEDURE UpdatePassword (UserId USERS.ID_USER%TYPE, NewPassword USERS.Password%type);
   PROCEDURE UpdateLogin (UserId USERS.ID_USER%TYPE, NewLogin USERS.LOGIN%type);
   PROCEDURE DeleteUser(IdUser USERS.ID_USER%TYPE);
   PROCEDURE ShowInfoUser(IdUser USERS.ID_USER%TYPE);
   PROCEDURE GetAllUsers;
   PROCEDURE GetHistoryActionUsers;
    --function--
        FUNCTION GetUserId (CustId CUSTOMERS.ID_CUSTOMER%TYPE) RETURN INTEGER;
END package_admin_user;


CREATE OR REPLACE PACKAGE BODY package_admin_user
AS
 ------------------Регистрация admin------------------
PROCEDURE Register_user_admin
(
UserName USERS.LOGIN%TYPE,
PasswordUser USERS.PASSWORD%TYPE
)
IS
BEGIN
        INSERT INTO USERS(TYPE_OF_USER,LOGIN,PASSWORD,ACTIVE) VALUES ('ADMIN',UserName,PasswordUser,1);
        DBMS_OUTPUT.PUT_LINE('Пользователь успешно зарегестрирован!');
        commit;
EXCEPTION
    when others
        then raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
end Register_user_admin;
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
-------------------------------------------------
-----------------------Удаление пользователя-----
PROCEDURE DeleteUser(IdUser USERS.ID_USER%TYPE)
IS
    Usr USERS%ROWTYPE;
BEGIN
    SELECT * INTO Usr FROM USERS WHERE ID_USER=IdUser;
    UPDATE USERS SET ACTIVE=0 WHERE ID_USER=IdUser;
    commit;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,'Такого пользователя не существует');
     WHEN OTHERS THEN
        raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
END DeleteUser;
-------------------------------------------------
----------Получить всех пользователей------------
PROCEDURE GetAllUsers
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
    close users_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetAllUsers;
-------------------------------------
--------------История пользователей--
PROCEDURE GetHistoryActionUsers
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
    close history_actions_curs;
EXCEPTION
     WHEN OTHERS THEN
     raise_application_error('code: '||sqlcode,'error: '||sqlerrm);
 --rollback;
end GetHistoryActionUsers;
    --------------------------
    -----------------------------------FUNCTIONS----------------
FUNCTION GetUserId (CustId CUSTOMERS.ID_CUSTOMER%TYPE)
RETURN INTEGER IS Id INTEGER;
BEGIN
SELECT USER_ID INTO Id FROM CUSTOMERS WHERE CustId = ID_CUSTOMER;
RETURN Id;
EXCEPTION
    when others then return -1;
END GetUserId;

    END package_admin_user;