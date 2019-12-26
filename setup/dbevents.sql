CREATE EVENT se_tbl_orders_tbl_needs
    ON SCHEDULE EVERY 1 DAY
    STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 MINUTE
  DO
    INSERT INTO tbl_orders(need_id, customer_id, kettle_type, number_of_kettles, total_amount, created_at, modified_at)
 		SELECT id,
 			   customer_id,
    		   kettle_id,
    		   num_of_kettles,
    		   (num_of_kettles *  rate_per_kettle) total_amount,
    		   NOW(),
    		   NOW()
    	FROM   tbl_needs
    	WHERE  status = "ENABLED"
    	AND	   day_to_deliver = DAYNAME(NOW());
