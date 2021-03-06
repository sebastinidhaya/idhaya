DELIMITER $$

USE `transport`$$

DROP PROCEDURE IF EXISTS `SPLITTING_CONTAINER_REPORT`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SPLITTING_CONTAINER_REPORT`(IN F_DATE DATETIME, IN T_DATE DATETIME)
BEGIN
	DECLARE TEMP_OTHER_TRIP_CHARGE INT DEFAULT 0;
	DROP TEMPORARY TABLE IF EXISTS LOAD_TYPES;
	DROP TEMPORARY TABLE IF EXISTS LOADING_COST; 
	DROP TEMPORARY TABLE IF EXISTS PNR_COST; 

	CREATE TEMPORARY TABLE LOADING_COST(id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	PICKUP VARCHAR(30) NULL,
	DELIVERY VARCHAR(30) NULL,	
	LOAD_TYPE VARCHAR(15) NULL,SIZE INT NULL, TYPE VARCHAR(5) NULL,NUM_OF_CONTAINER INT NULL,
	CONTAINERS_PER_PLOT INT NULL,TARIFF_CHARGE INT NULL, TOTAL_AMOUNT INT NULL); 

	CREATE TEMPORARY TABLE LOAD_TYPES(id INT NOT NULL AUTO_INCREMENT PRIMARY KEY) 
	SELECT DISTINCT B.LOAD_TYPE FROM TRACK_VEHICLE AS A INNER JOIN TRACK_CONTAINER AS B ON A.TRIP_ID=B.TRACK_ID 
	WHERE A.UNLOAD_DATE BETWEEN F_DATE AND T_DATE;

	CREATE TEMPORARY TABLE PNR_COST(SELECT  A.TRIP_ID,A.PICKUP,A.DELIVERY,A.TRIP_CHARGE,A.TOTAL_TRIP_CHARGE, B.SIZE, B.TYPE, B.LOAD_TYPE, COUNT(B.TRACK_ID)NO_OF_CON FROM TRACK_VEHICLE AS A INNER JOIN TRACK_CONTAINER AS B INNER JOIN LOAD_TYPES AS C
	ON A.TRIP_ID=B.TRACK_ID
	WHERE C.LOAD_TYPE = B.LOAD_TYPE AND A.UNLOAD_DATE BETWEEN F_DATE AND T_DATE GROUP BY A.TRIP_ID);


	INSERT INTO LOADING_COST (PICKUP, DELIVERY, LOAD_TYPE, SIZE, TYPE, NUM_OF_CONTAINER,CONTAINERS_PER_PLOT, TARIFF_CHARGE, TOTAL_AMOUNT)
	SELECT A.PICKUP, A.DELIVERY, A.LOAD_TYPE,A.SIZE, A.TYPE,A.NO_OF_CON , SUM(A.NO_OF_CON),A.TRIP_CHARGE ,SUM(A.TOTAL_TRIP_CHARGE)
	FROM PNR_COST AS A INNER JOIN  LOAD_TYPES AS B INNER JOIN CON_SIZE AS C INNER JOIN CON_TYPE AS D INNER JOIN NUMBER_OF_CONTAINERS AS E
	WHERE  A.LOAD_TYPE= B.LOAD_TYPE AND A.SIZE = C.SIZE  AND A.TYPE = D.TYPE AND A.NO_OF_CON = E.NO_OF_CON
	GROUP BY A.LOAD_TYPE,A.TYPE,A.SIZE,A.PICKUP,A.DELIVERY,E.NO_OF_CON ORDER BY LOAD_TYPE;
	
	SELECT SUM(D.TOTAL_TRIP_CHARGE) INTO TEMP_OTHER_TRIP_CHARGE FROM TRACK_VEHICLE D
	WHERE NOT EXISTS(SELECT TRIP_ID FROM TRACK_CONTAINER C WHERE D.TRIP_ID = C.TRACK_ID) AND UNLOAD_DATE BETWEEN F_DATE AND T_DATE;
	INSERT INTO LOADING_COST(LOAD_TYPE, TOTAL_AMOUNT) VALUES ('OTHERS',TEMP_OTHER_TRIP_CHARGE);

	DROP TEMPORARY TABLE IF EXISTS PNR_COST;
	DROP TEMPORARY TABLE IF EXISTS LOAD_TYPES; 
	SELECT * FROM LOADING_COST;

	END$$

DELIMITER ;