SELECT
          tabkey.PAYMENT_DATE
        , tabkey.DRIVER_ID
        , IFNULL(ADVANCE_PAYMENT.AMOUNT, 0) AS DEBIT
        , IFNULL(ADVANCE_CREDIT.AMOUNT, 0)  AS CREDIT
FROM
          (
                 SELECT
                        ADVANCE_PAYMENT.PAYMENT_DATE
                      , ADVANCE_PAYMENT.CREATED_DATE
                      , ADVANCE_PAYMENT.DRIVER_ID
                 FROM
                        ADVANCE_PAYMENT
                 WHERE
                        ADVANCE_PAYMENT.DRIVER_ID = 6
                 UNION
                 SELECT
                        ADVANCE_CREDIT.CREDIT_DATE
                      , ADVANCE_CREDIT.CREATED_DATE
                      , ADVANCE_CREDIT.DRIVER_ID
                 FROM
                        ADVANCE_CREDIT
                 WHERE
                        ADVANCE_CREDIT.DRIVER_ID = 6
          )
          AS tabkey
          LEFT JOIN
                    ADVANCE_PAYMENT
                    ON
                              tabkey.CREATED_DATE = ADVANCE_PAYMENT.CREATED_DATE
          LEFT JOIN
                    ADVANCE_CREDIT
                    ON
                              tabkey.CREATED_DATE = ADVANCE_CREDIT.CREATED_DATE
;