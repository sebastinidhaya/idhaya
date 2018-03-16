DELIMITER $$ USE `transport`$$ DROP PROCEDURE
IF EXISTS `ADVANCE_DRIVER_LEDGER`$$ CREATE DEFINER=`root`@`localhost`
PROCEDURE `ADVANCE_DRIVER_LEDGER`
                                 (
                                     IN DRIV_ID INT
                                 )
    BEGIN
        /*SELECT DATE_FORMAT(PAYMENT_DATE, '%d-%m-%Y') AS PAYMENT_DATE, AMOUNT, REMARKS FROM ADVANCE_PAYMENT WHERE DRIVER_ID = ID and
        MONTH(PAYMENT_DATE) = MONTH(CURRENT_DATE()) AND YEAR(PAYMENT_DATE) = YEAR(CURRENT_DATE()) ORDER BY PAYMENT_DATE;*/
        SELECT
                  tabkey.PAYMENT_DATE
                , tabkey.REMARKS
                , IFNULL(ADVANCE_PAYMENT.AMOUNT, 0) AS DEBIT
                , IFNULL(ADVANCE_CREDIT.AMOUNT, 0)  AS CREDIT
        FROM
                  (
                           SELECT
                                    ADVANCE_PAYMENT.PAYMENT_DATE
                                  , ADVANCE_PAYMENT.REMARKS
                                  , ADVANCE_PAYMENT.DRIVER_ID
                           FROM
                                    ADVANCE_PAYMENT
                           WHERE
                                    ADVANCE_PAYMENT.DRIVER_ID = DRIV_ID
                           GROUP BY
                                    ADVANCE_PAYMENT.PAYMENT_DATE
                           UNION ALL
                           SELECT
                                    ADVANCE_CREDIT.CREDIT_DATE
                                  , ADVANCE_CREDIT.REMARKS
                                  , ADVANCE_CREDIT.DRIVER_ID
                           FROM
                                    ADVANCE_CREDIT
                           WHERE
                                    ADVANCE_CREDIT.DRIVER_ID = DRIV_ID
                           GROUP BY
                                    ADVANCE_CREDIT.CREDIT_DATE
                  )
                  AS tabkey
                  LEFT JOIN
                            ADVANCE_PAYMENT
                            ON
                                      tabkey.PAYMENT_DATE           = ADVANCE_PAYMENT.PAYMENT_DATE
                                      AND ADVANCE_PAYMENT.DRIVER_ID = DRIV_ID
                  LEFT JOIN
                            ADVANCE_CREDIT
                            ON
                                      tabkey.PAYMENT_DATE          = ADVANCE_CREDIT.CREDIT_DATE
                                      AND ADVANCE_CREDIT.DRIVER_ID = DRIV_ID
        ;
        
        END$$ DELIMITER;