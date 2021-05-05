CREATE DIRECTORY TEMP
  AS 'A:\TEMP' ;

-- with cte as (
--     select ID_ORDER,CUSTOMER_ID,DELIVERYMETHOD_ID,PAYMENTMETHOD_ID,
--     CITY_ID,STATUS_ID
--     from ORDERS
--     )
-- SELECT xmlroot (
--   XMLElement(
--     "Orders",
--        XMLAgg(XMLElement("Order",
--                          XMLAttributes(cte.ID_ORDER as "id"),
--                          XMLElement("Customer_Id",cte.CUSTOMER_ID),
--                          XMLElement("DELIVERY",cte.DELIVERYMETHOD_ID),
--                          XMLElement("PAYMENTMETHOD",cte.PAYMENTMETHOD_ID),
--                          XMLElement("CITY_ID",cte.CITY_ID),
--                          XMLElement("STATUS_ID",cte.STATUS_ID)
--                          )
--       )
--       )
--     , version '1.0'   )
-- FROM cte;

CREATE OR REPLACE PACKAGE XML_PACKAGE IS
  PROCEDURE EXPORT_ORDERS_TO_XML;
  PROCEDURE ADDCITY(xml IN CLOB);
END XML_PACKAGE;

CREATE OR REPLACE PACKAGE BODY XML_PACKAGE IS
--------------------------------------------------------------------------------
PROCEDURE EXPORT_ORDERS_TO_XML
IS
  DOC  DBMS_XMLDOM.DOMDocument;
  XDATA  XMLTYPE;
  CURSOR XMLCUR IS
    SELECT XMLELEMENT("Orders",
      XMLAttributes('http://www.w3.org/2001/XMLSchema' AS "xmlns:xsi",
      'http://www.oracle.com/Employee.xsd' AS "xsi:nonamespaceSchemaLocation"),
      XMLAGG(XMLELEMENT("USER",
       XMLELEMENT("ID_ORDER",O.ID_ORDER),
       XMLElement("CUSTOMER_ID",O.DELIVERYMETHOD_ID),
       XMLElement("DELIVERYMETHOD_ID",O.PAYMENTMETHOD_ID),
       XMLElement("PAYMENTMETHOD_ID",O.ADDRESS),
       XMLElement("CITY_ID",O.CITY_ID),
       XMLElement("STATUS_ID",O.STATUS_ID),
       XMLElement("CUSTOMER_ID",O.CUSTOMER_ID)
      ))
) FROM ORDERS O;
BEGIN
  OPEN XMLCUR;
    LOOP
      FETCH XMLCUR INTO XDATA;
    EXIT WHEN XMLCUR%NOTFOUND;
    END LOOP;
  CLOSE XMLCUR;
  DOC := DBMS_XMLDOM.NewDOMDocument(XDATA);
  DBMS_XMLDOM.WRITETOFILE(DOC, 'TEMP/orders.xml');
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20102, 'EXPORT XML ERROR');
END EXPORT_ORDERS_TO_XML;
--------------------------------------------------------------------------------
PROCEDURE ADDCITY
    (xml IN CLOB)
AS
BEGIN
    INSERT INTO cities (CITY_NAME)
    SELECT  *
  FROM  XMLTable('/root/row'
                 passing xmltype(
                                 bfilename('TEMP','cities.xml'),
                                 nls_charset_id('AL32UTF8')
                                )
                 columns city_name varchar2(300) path 'title_ru'
                )
    COMMIT;
END ADDCITY;
--------------------------------------------------------------------------------
END XML_PACKAGE;

