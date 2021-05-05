--Indexes

--OrdersINDEX
CREATE  INDEX index_orders_customer ON ORDERS(CUSTOMER_ID);

--drop index index_orders_customer;
--
--OrdersDetailsINDEX
CREATE INDEX index_ordersDetails ON ORDER_DETAILS(ORDER_ID);
CREATE INDEX index_ordersDetails_product ON ORDER_DETAILS(PRODUCT_ID);
--
--HistoryOrdersINDEX
CREATE  INDEX index_HistoryOrders_CreareAt ON HISTORY_ORDERS(CREATEAT);

select CUSTOMER_ID from ORDERS;
select ORDER_ID from ORDER_DETAILS;