CREATE OR REPLACE PROCEDURE ADD_CUST_TO_DB(pcustid NUMBER, pcustname VARCHAR2) AS 
INDEX_OUT_OF_RANGE EXCEPTION;
BEGIN
IF pcustid < 1 OR pcustid >499 THEN
RAISE INDEX_OUT_OF_RANGE;
END IF;
INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS)
VALUES (pcustid, pcustname, 0, 'OK');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
RAISE_APPLICATION_ERROR(-20017,'Duplicated customer ID',FALSE);
WHEN INDEX_OUT_OF_RANGE THEN
RAISE_APPLICATION_ERROR(-20029,'Customer ID out of range');
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE ADD_CUSTOMER_VIASQLDEV(pcustid NUMBER, pcustname VARCHAR2) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Adding Customer. ID: '||pcustid||' Name: '|| pcustname);
    ADD_CUST_TO_DB(pcustid, pcustname);
    IF(SQL%ROWCOUNT >0)THEN
    dbms_output.put_line('Customer Added OK');
    COMMIT;
    END IF;
    EXCEPTION 
    WHEN OTHERS THEN 
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION DELETE_ALL_CUSTOMERS_FROM_DB
RETURN NUMBER AS vNum NUMBER :=0;
BEGIN
DELETE FROM CUSTOMER;
vNum := SQL%ROWCOUNT;
RETURN vNum; 
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_CUSTOMERS_VIASQLDEV AS
vCount NUMBER;
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting all Customer rows');
    vCount := DELETE_ALL_CUSTOMERS_FROM_DB;
    if(vCount >0)THEN
    dbms_output.put_line(vCount|| ' rows deleted');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--Part 1.3
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_TO_DB (pprodid NUMBER, pprodname VARCHAR2, pprice NUMBER) AS
INDEX_OUT_OF_RANGE EXCEPTION;
PRICE_OUT_OF_RANGE EXCEPTION;
BEGIN
    IF pprodid < 1000 OR pprodid > 2500 THEN
    RAISE INDEX_OUT_OF_RANGE;
    END IF;
    IF pprice < 0 or pprice > 999.99 THEN
    RAISE PRICE_OUT_OF_RANGE;
    END IF;
    INSERT INTO PRODUCT (PRODID, PRODNAME,SELLING_PRICE,SALES_YTD) 
    VALUES (pprodid,pprodname,pprice,0);
    EXCEPTION
    WHEN INDEX_OUT_OF_RANGE THEN
    RAISE_APPLICATION_ERROR(-20049,'Product ID out of range');
    WHEN PRICE_OUT_OF_RANGE THEN
    RAISE_APPLICATION_ERROR(-20056, 'Price out of range');
    WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20037,'Duplicated product ID');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_VIASQLDEV(pprodid NUMBER, pprodname VARCHAR2, pprice NUMBER) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Adding Product ID:'|| pprodid ||' Name:'|| pprodname || ' Price:'|| pprice);
    ADD_PRODUCT_TO_DB(pprodid, pprodname,pprice);
    IF(SQL%ROWCOUNT >0) THEN
      dbms_output.put_line('Product Added OK');
      COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION DELETE_ALL_PRODUCTS_FROM_DB 
RETURN NUMBER AS vNum NUMBER :=0;
BEGIN
DELETE FROM PRODUCT;
vNum := SQL%ROWCOUNT;
RETURN vNum; 
EXCEPTION
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_PRODUCTS_VIASQLDEV AS
vCount NUMBER;
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting all Product rows');
    vCount := DELETE_ALL_PRODUCTS_FROM_DB;
    if(vCount > 0) THEN
    dbms_output.put_line(vCount|| ' rows deleted');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--1.4 
CREATE OR REPLACE FUNCTION GET_CUST_STRING_FROM_DB(pcustid NUMBER) RETURN VARCHAR2 AS
vName VARCHAR2(100);
vStatus VARCHAR2(7);
vSales NUMBER;
vReturn VARCHAR2(200);
BEGIN
    SELECT CUSTNAME, STATUS, SALES_YTD
    INTO vName, vStatus, vSales
    FROM CUSTOMER 
    WHERE CUSTID = pcustid;
    vReturn := 'CustId: '|| pcustid||' Name: '|| vName || ' Status '|| vStatus||' SalesYTD: '|| vSales;
    RETURN vReturn;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20067,'Customer ID not found');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE GET_CUST_STRING_VIASQLDEV(pcustid NUMBER) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Getting Details for CustId'|| pcustid);
    dbms_output.put_line(GET_CUST_STRING_FROM_DB(pcustid));
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_SALESYTD_IN_DB  (pcustid Number, pamt Number) AS
AMT_OUT_OF_RANGE EXCEPTION;
ID_NOT_FOUND EXCEPTION;
BEGIN
    UPDATE CUSTOMER
    SET SALES_YTD = SALES_YTD + pamt
    WHERE CUSTID = pcustid;
    IF (SQL%ROWCOUNT = 0) THEN
    RAISE ID_NOT_FOUND;
    END IF;
    IF (pamt < -999.99 or pamt > 999.99) THEN
    RAISE AMT_OUT_OF_RANGE;
    END IF;
    EXCEPTION
    WHEN ID_NOT_FOUND THEN
    RAISE_APPLICATION_ERROR(-20077, 'Customer ID not found');
    WHEN AMT_OUT_OF_RANGE THEN
    RAISE_APPLICATION_ERROR(-20089, 'Amount out of range');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_SALESYTD_VIASQLDEV (pcustid Number, pamt Number) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Updating SalesYTD. Customer id: '||pcustid||' Amount: '|| pamt);
    UPD_CUST_SALESYTD_IN_DB(pcustid,pamt);
    IF (SQL%ROWCOUNT >0 )THEN
    dbms_output.put_line('Update OK');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--1.5
CREATE OR REPLACE FUNCTION GET_PROD_STRING_FROM_DB(pprodid NUMBER) RETURN VARCHAR2 AS
vPName VARCHAR2(100);
vPrice NUMBER;
vSales NUMBER;
vReturn VARCHAR2(200);
BEGIN
    SELECT PRODNAME, SELLING_PRICE, SALES_YTD
    INTO vPName, vPrice, vSales
    FROM PRODUCT 
    WHERE PRODID = pprodid;
    vReturn := 'Prodid: '|| pprodid||' Name: '|| vPName || ' Price '|| vPrice||' SalesYTD: '|| vSales;
    RETURN vReturn;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20097,'Product ID not found');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE GET_PROD_STRING_VIASQLDEV(pprodid NUMBER) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Getting Details for Prod Id '|| pprodid);
    dbms_output.put_line(GET_PROD_STRING_FROM_DB(pprodid));
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UPD_PROD_SALESYTD_IN_DB(pprodid Number, pamt Number) AS
ID_NOT_FOUND EXCEPTION;
AMT_OUT_OF_RANGE EXCEPTION;
BEGIN
    UPDATE PRODUCT
    SET SALES_YTD = SALES_YTD + pamt
    WHERE PRODID = pprodid;
    IF (SQL%ROWCOUNT = 0) THEN
    RAISE ID_NOT_FOUND;
    END IF;
    IF (pamt < -999.99 or pamt > 999.99) THEN
    RAISE AMT_OUT_OF_RANGE;
    END IF;
    EXCEPTION
    WHEN ID_NOT_FOUND THEN
    RAISE_APPLICATION_ERROR(-20107, 'Product ID not found');
    WHEN AMT_OUT_OF_RANGE THEN
    RAISE_APPLICATION_ERROR(-20119, 'Amount out of range');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UPD_PROD_SALESYTD_VIASQLDEV (pprodid Number, pamt Number) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Updating SalesYTD. Product Id: '||pprodid||' Amount: '|| pamt);
    UPD_PROD_SALESYTD_IN_DB(pprodid,pamt);
    IF (SQL%ROWCOUNT >0 )THEN
    dbms_output.put_line('Update OK');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--1.6
CREATE OR REPLACE PROCEDURE UPD_CUST_STATUS_IN_DB  (pcustid Number, pstatus VARCHAR2) AS
INVALID_STATUS EXCEPTION;
NO_ROWS_UPDATED EXCEPTION;
BEGIN
    IF (pstatus ='OK' or pstatus = 'SUSPEND') THEN
        UPDATE CUSTOMER
        SET STATUS = pstatus
        WHERE CUSTID = pcustid;
        IF (SQL%NOTFOUND) THEN
        RAISE NO_ROWS_UPDATED;
        END IF;
    ELSE
        RAISE INVALID_STATUS;
    END IF;
    EXCEPTION
    WHEN NO_ROWS_UPDATED THEN 
    RAISE_APPLICATION_ERROR(-20127, 'Customer ID not found');
    WHEN INVALID_STATUS THEN 
    RAISE_APPLICATION_ERROR(-20139, 'Invalid Status value');
    WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_STATUS_VIASQLDEV (pcustid Number, pstatus VARCHAR2) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Updating Status. Id: '||pcustid||' New Status: '|| pstatus);
    UPD_CUST_STATUS_IN_DB  (pcustid , pstatus );
    IF (SQL%ROWCOUNT >0 )THEN
    dbms_output.put_line('Update OK');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--1.7
CREATE OR REPLACE PROCEDURE ADD_SIMPLE_SALE_TO_DB  (pcustid NUMBER, pprodid NUMBER, pqty NUMBER) AS
INVALID_QTY_RANGE EXCEPTION;
INVALID_STATUS EXCEPTION;
NO_MATCH_CUST_ID EXCEPTION;
NO_MATCH_PROD_ID EXCEPTION;
vProductprice  NUMBER;
vYTD  NUMBER;
vStatus VARCHAR2(7);
BEGIN
vStatus := '';
vProductprice := '';
SELECT STATUS INTO vStatus FROM CUSTOMER WHERE CUSTID = pcustid;
IF (vStatus = '') THEN
RAISE NO_MATCH_CUST_ID;
ELSIF (vStatus !='OK') THEN
RAISE INVALID_STATUS;
END IF;
IF(pqty<0 OR pqty > 999) THEN
RAISE INVALID_QTY_RANGE;
END IF;
SELECT SELLING_PRICE INTO vProductprice FROM PRODUCT WHERE PRODID =pprodid;
IF (vProductprice = '') THEN
RAISE NO_MATCH_PROD_ID;
END IF;
vYTD :=pqty * vProductprice;
UPD_CUST_SALESYTD_IN_DB(pcustid, vYTD);
UPD_PROD_SALESYTD_IN_DB(pprodid, vYTD);
EXCEPTION
WHEN NO_MATCH_PROD_ID THEN  
RAISE_APPLICATION_ERROR(-20172, 'Product ID not found');
WHEN NO_MATCH_CUST_ID THEN
RAISE_APPLICATION_ERROR(-20166, 'Customer ID not found');
WHEN INVALID_QTY_RANGE THEN
RAISE_APPLICATION_ERROR(-20147, 'Sale Quantity outside valid range');
WHEN INVALID_STATUS THEN
RAISE_APPLICATION_ERROR(-20159,'Customer status is not OK');
WHEN OTHERS THEN 
RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE ADD_SIMPLE_SALE_VIASQLDEV (pcustid NUMBER, pprodid NUMBER, pqty NUMBER) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Adding Simple Sale. Cust Id: '||pcustid||' Prod Id '|| pprodid||' Qty: '||pqty);
    ADD_SIMPLE_SALE_TO_DB  (pcustid , pprodid, pqty);
    IF (SQL%ROWCOUNT >0 )THEN
    dbms_output.put_line('Added Simple Sale OK');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END; 
/
--1.8
CREATE OR REPLACE FUNCTION SUM_CUST_SALESYTD RETURN NUMBER AS
vSum NUMBER;
BEGIN
    SELECT SUM(SALES_YTD)
    INTO vSum
    FROM CUSTOMER;
    RETURN vSum;
    EXCEPTION
    WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE SUM_CUST_SALES_VIASQLDEV  AS
vSum NUMBER;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    vSum := SUM_CUST_SALESYTD; 
    IF (SQL%FOUND) THEN
    dbms_output.put_line('All Customer Total:  '|| vSum);
    ELSE
    dbms_output.put_line('All Customer Total: 0');
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION SUM_PROD_SALESYTD_FROM_DB RETURN NUMBER AS
vSum NUMBER;
BEGIN
    SELECT SUM(SALES_YTD)
    INTO vSum
    FROM PRODUCT;
    RETURN vSum;
    EXCEPTION
    WHEN OTHERS THEN 
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE SUM_PROD_SALES_VIASQLDEV  AS
vSum NUMBER;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    vSum := SUM_CUST_SALESYTD; 
    IF (SQL%FOUND) THEN
    dbms_output.put_line('All Customer Total:  '|| vSum);
    ELSE
    dbms_output.put_line('All Customer Total: 0');
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--2.1
CREATE OR REPLACE FUNCTION GET_ALLCUST RETURN SYS_REFCURSOR AS
custcursor SYS_REFCURSOR;
BEGIN
    open custcursor for select * from CUSTOMER;
    RETURN custcursor;
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE GET_ALLCUST_VIASQLDEV AS
custcursor SYS_REFCURSOR;
custrec customer%ROWTYPE;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Listing All Customer Details');
    custcursor := GET_ALLCUST;
    IF(SQL%NOTFOUND) THEN
    dbms_output.put_line('No rows found');
    END IF;
    LOOP
    FETCH custcursor INTO custrec;
    EXIT WHEN custcursor%NOTFOUND;
    dbms_output.put_line('CustID:'||custrec.CUSTID||' Name:'||custrec.CUSTNAME||' Status:'||custrec.STATUS||' SalesYTD:'||custrec.SALES_YTD) ;
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION GET_ALLPROD_FROM_DB RETURN SYS_REFCURSOR AS
prodcursor SYS_REFCURSOR;
BEGIN
    open prodcursor for select * from PRODUCT;
    RETURN prodcursor;
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE GET_ALLPROD_VIASQLDEV AS
prodcursor SYS_REFCURSOR;
prodrec product%ROWTYPE;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Listing All Product Details');
    prodcursor := GET_ALLPROD_FROM_DB;
    IF(SQL%NOTFOUND) THEN
    dbms_output.put_line('No rows found');
    END IF;
    LOOP
    FETCH prodcursor INTO prodrec;
    EXIT WHEN prodcursor%NOTFOUND;
    dbms_output.put_line('ProdID:'||prodrec.PRODID||' Name:'||prodrec.PRODNAME||' Price:'||prodrec.SELLING_PRICE||' SalesYTD:'||prodrec.SALES_YTD) ;
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--part 3
create or replace FUNCTION strip_constraint (pErrmsg VARCHAR2) return VARCHAR2 AS
rp_loc NUMBER;
dot_loc NUMBER;
BEGIN
    dot_loc := INSTR(pErrmsg, '.');
    rp_loc := INSTR(pErrmsg, ')');
    IF(dot_loc = 0 OR rp_loc = 0) THEN
        RETURN NULL;
    ELSE
        RETURN UPPER(SUBSTR(pErrmsg, dot_loc+1, rp_loc-dot_loc -1));
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE ADD_LOCATION_TO_DB(ploccode VARCHAR2,pminqty NUMBER,pmaxqty NUMBER) AS
dbms_constraint_name VARCHAR2(240);
INVALID_LENGTH EXCEPTION;
BEGIN
    IF (LENGTH(ploccode) !=5) THEN
    RAISE INVALID_LENGTH;
    END if;
    INSERT INTO LOCATION (LOCID, MINQTY, MAXQTY) VALUES (ploccode, pminqty,pmaxqty);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    RAISE_APPLICATION_ERROR(-20187, 'Duplicated location ID');
    WHEN INVALID_LENGTH THEN
    RAISE_APPLICATION_ERROR(-20199,'Location Code length invalid');
    WHEN OTHERS THEN
    dbms_constraint_name := strip_constraint(SQLERRM);
    IF (dbms_constraint_name ='CHECK_MINQTY_RANGE') THEN
    RAISE_APPLICATION_ERROR(-20206,'Minimum Qty out of range');
    ELSIF (dbms_constraint_name ='CHECK_MAXQTY_RANGE') THEN
    RAISE_APPLICATION_ERROR(-20212,'Maximum Qty out of range');
    ELSIF (dbms_constraint_name ='CHECK_MAXQTY_GREATER_MIXQTY') THEN
    RAISE_APPLICATION_ERROR(-20224,'Minimum Qty larger than Maximum Qty');
    ELSE
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
    END IF;
END;
/
CREATE OR REPLACE PROCEDURE ADD_LOCATION_VIASQLDEV(ploccode VARCHAR2,pminqty NUMBER,pmaxqty NUMBER) AS
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Adding Locatino LocCode: '||ploccode||' MinQty: '|| pminqty||' MaxQty: '|| pmaxqty);
    ADD_LOCATION_TO_DB(ploccode ,pminqty ,pmaxqty );
    IF(SQL%ROWCOUNT >0)THEN
    dbms_output.put_line('Location Added OK');
    COMMIT;
    END IF;
    EXCEPTION 
    WHEN OTHERS THEN 
    dbms_output.put_line(SQLERRM);
END;
/
--p4
CREATE OR REPLACE PROCEDURE ADD_COMPLEX_SALE_TO_DB(pcustid NUMBER, pprodid NUMBER,pqty NUMBER,pdate VARCHAR2) AS
vStatus customer.status%type;
vCountCust NUMBER;
vCountProd NUMBER;
vDate DATE;
vAmt NUMBER;
vPrice NUMBER;
QTY_OUT_OF_RANGE EXCEPTION;
INVALID_STATUS EXCEPTION;
INVALID_DATE_LENGTH EXCEPTION;
NO_CUST_FOUND EXCEPTION;
NO_PROD_FOUND EXCEPTION;
BEGIN
IF (pqty < 1 or pqty > 999) THEN
RAISE QTY_OUT_OF_RANGE;
END IF;
IF(length(pdate) != 8)THEN
RAISE INVALID_DATE_LENGTH;
END IF;
SELECT COUNT(*) INTO vCountCust FROM CUSTOMER WHERE CUSTID = pcustid;
IF(vCountCust = 0)THEN
RAISE NO_CUST_FOUND;
END IF;
SELECT STATUS INTO vStatus FROM CUSTOMER WHERE CUSTID = pcustid;
IF(upper(vStatus) != 'OK')THEN
RAISE INVALID_STATUS;
END IF;
SELECT COUNT(*) INTO vCountProd FROM PRODUCT WHERE PRODID = pprodid;
IF(vCountProd = 0)THEN
RAISE NO_PROD_FOUND;
END IF;
SELECT SELLING_PRICE INTO vPrice FROM PRODUCT WHERE PRODID = pprodid;
--INSERT to SALE TABLE STATEMENT
INSERT INTO SALE (SALEID,CUSTID,PRODID,QTY,PRICE,SALEDATE)
VALUES(SALE_SEQ.nextval,pcustid,pprodid,pqty,vPrice, vDate);
--UPDATE CUSTOMER AND PRODUCT TABLE
vAmt := pqty *vPrice;
UPD_CUST_SALESYTD_IN_DB(pcustid, vAmt);
UPD_PROD_SALESYTD_IN_DB(pprodid, vAmt);
EXCEPTION
WHEN QTY_OUT_OF_RANGE THEN
RAISE_APPLICATION_ERROR(-20237,'Sale Quantity outside valid range');
WHEN INVALID_STATUS THEN
RAISE_APPLICATION_ERROR(-20249,'Customer status is not OK');
WHEN INVALID_DATE_LENGTH THEN
RAISE_APPLICATION_ERROR(-20256,'Date not valid');
WHEN NO_CUST_FOUND THEN
RAISE_APPLICATION_ERROR(-20262,'Customer ID not found');
WHEN NO_PROD_FOUND THEN
RAISE_APPLICATION_ERROR(-20274,'Product ID not found');
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE ADD_COMPLEX_SALE_VIASQLDEV(pcustid NUMBER, pprodid NUMBER,pqty NUMBER,pdate VARCHAR2) AS
vPrice NUMBER;
vAmt NUMBER;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    SELECT SELLING_PRICE INTO vPrice FROM PRODUCT WHERE PRODID =pprodid;
    vAmt := vPrice * pqty;
    dbms_output.put_line('Adding Complex Sale. Cust Id: '||pcustid||' Prod Id '|| pprodid||' Date:'|| pdate||' Amt:'||vAmt);
    ADD_COMPLEX_SALE_TO_DB(pcustid , pprodid ,pqty ,pdate );
    IF(SQL%ROWCOUNT >0)THEN
    dbms_output.put_line('Added Complex Sale OK');
    COMMIT;
    END IF;
    EXCEPTION 
    WHEN OTHERS THEN 
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION GET_ALLSALES_FROM_DB RETURN SYS_REFCURSOR AS
salecursor SYS_REFCURSOR;
BEGIN
    open salecursor for select * from SALE;
    RETURN salecursor;
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE GET_ALLSALES_VIASQLDEV AS
salecursor SYS_REFCURSOR;
salerec sale%ROWTYPE;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Listing All Customer Details');
    salecursor := GET_ALLSALES_FROM_DB;
    IF(SQL%NOTFOUND) THEN
    dbms_output.put_line('No rows found');
    END IF;
    LOOP
    FETCH salecursor INTO salerec;
    EXIT WHEN salecursor%NOTFOUND;
    dbms_output.put_line('SaleID:'||salerec.SALEID||' Custid:'||salerec.CUSTID||' Prodid:'||salerec.PRODID||' Date'||salerec.SALEDATE||' Amount:'|| salerec.QTY * salerec.PRICE) ;
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE FUNCTION COUNT_PRODUCT_SALES_FROM_DB(pdays NUMBER) RETURN NUMBER AS
vCount NUMBER;
BEGIN
    SELECT COUNT(*) INTO vCount FROM SALE WHERE ((SYSDATE-SALEDATE)<pdays);
    RETURN vCount;
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE COUNT_PRODUCT_SALES_VIASQLDEV (pdays NUMBER) AS
vCount NUMBER;
BEGIN
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Counting sales within  '|| pdays||' days');
    vCount := COUNT_PRODUCT_SALES_FROM_DB(pdays); 
    IF (vCount >0) THEN
    dbms_output.put_line('Total number of sales:'|| vCount);
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--p5
create or replace function DELETE_SALE_FROM_DB return NUMBER AS
vSaleId NUMBER;
vAmt NUMBER;
vqty SALE.QTY%TYPE;
vPrice SALE.PRICE%TYPE;
vCustId SALE.CUSTID%TYPE;
vProdId SALE.PRODID%TYPE;
NO_SALE_FOUND EXCEPTION;
BEGIN
SELECT MIN(SALEID) INTO vSaleId FROM SALE;
SELECT CUSTID, PRODID, QTY, PRICE 
INTO vCustId, vProdId, vQty, vPrice
FROM SALE
WHERE SALEID = vSaleId;
vAmt := vqty * vprice;
UPDATE CUSTOMER SET SALES_YTD = SALES_YTD - vAmt;
UPDATE PRODUCT SET SALES_YTD = SALES_YTD - vAmt;
Delete from SALE WHERE SALEID =vSaleId;
RETURN vSaleId;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR(-20287,'No Sale Rows Found');
WHEN others THEN
RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_SALE_VIASQLDEV AS
vId NUMBER;
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting Sale with smallest SaleId value');
    vId:=DELETE_SALE_FROM_DB;
    if(SQL%ROWCOUNT >0) THEN
    dbms_output.put_line('Deleted Sale OK. SaleID:'||vId);
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_SALES_FROM_DB AS
BEGIN
    DELETE FROM SALE;
    UPDATE CUSTOMER 
    SET SALES_YTD = 0;
    UPDATE PRODUCT 
    SET SALES_YTD = 0; 
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_SALES_VIASQLDEV AS
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting all Sales data in Sale, Customer, and Product tables');
    DELETE_ALL_SALES_FROM_DB;
    if(SQL%ROWCOUNT >0) THEN
    dbms_output.put_line('Deleted Sale OK.');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
--p6
create or REPLACE PROCEDURE DELETE_CUSTOMER(pCustid NUMBER) AS
NO_MATCHING_ID EXCEPTION;
CHILD_COMPLEX_ROW EXCEPTION;
PRAGMA EXCEPTION_INIT(CHILD_COMPLEX_ROW, -2292);
BEGIN
DELETE FROM CUSTOMER WHERE CUSTID = pCustid;
IF (SQL%ROWCOUNT = 0)THEN
RAISE NO_MATCHING_ID;
END IF;
EXCEPTION
WHEN NO_MATCHING_ID THEN
RAISE_APPLICATION_ERROR(-20297, 'Customer ID not found');
WHEN CHILD_COMPLEX_ROW THEN
RAISE_APPLICATION_ERROR(-20309, 'Customer cannot be deleted as sales exist');
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_CUSTOMER_VIASQLDEV(pCustid NUMBER) AS
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting Customer. Cust Id:'||pCustid);
    DELETE_CUSTOMER(pCustid);
    if(SQL%ROWCOUNT >0) THEN
    dbms_output.put_line('Deleted Customer OK.');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/
create or replace PROCEDURE DELETE_PROD_FROM_DB (pProdid NUMBER) AS
NO_MATCHING_ID EXCEPTION;
CHILD_COMPLEX_ROW EXCEPTION;
PRAGMA EXCEPTION_INIT(CHILD_COMPLEX_ROW, -2292);
BEGIN
    DELETE FROM PRODUCT
    WHERE PRODID = pProdid;
    IF(SQL%ROWCOUNT = 0) THEN
    RAISE NO_MATCHING_ID;
    END IF;
    EXCEPTION
    WHEN NO_MATCHING_ID THEN
    RAISE_APPLICATION_ERROR(-20317, 'Product ID not found');
    WHEN CHILD_COMPLEX_ROW THEN
    RAISE_APPLICATION_ERROR(-20329, 'Product cannot be deleted as sales exist');
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000, SQLERRM);
END;
/
CREATE OR REPLACE PROCEDURE DELETE_PROD_VIASQLDEV(pProdid NUMBER) AS
BEGIN 
    dbms_output.put_line('--------------------------------------------');
    dbms_output.put_line('Deleting Customer. Cust Id:'||pProdid);
    DELETE_PROD_FROM_DB(pProdid);
    if(SQL%ROWCOUNT >0) THEN
    dbms_output.put_line('Deleted Product OK.');
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/