/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table tbl_complete_payments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_complete_payments`;

CREATE TABLE `tbl_complete_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) unsigned NOT NULL,
  `amount_paid` float unsigned DEFAULT '0',
  `is_partial` enum('YES','NO') DEFAULT 'NO',
  `created_at` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `modified_at` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `fk_order_id_tbl_orders_tbl_complete_payments` (`order_id`),
  CONSTRAINT `fk_order_id_tbl_orders_tbl_complete_payments` FOREIGN KEY (`order_id`) REFERENCES `tbl_orders` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tbl_customer_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_customer_details`;

CREATE TABLE `tbl_customer_details` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(256) NOT NULL DEFAULT '',
  `last_name` varchar(256) DEFAULT '',
  `contact_number` varchar(11) DEFAULT NULL,
  `city` varchar(256) DEFAULT 'Udaipur',
  `state` varchar(256) DEFAULT 'Rajasthan',
  `street_address` varchar(2048) NOT NULL DEFAULT '',
  `email_id` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `modified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

# Dump of table tbl_kettle_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_kettle_types`;

CREATE TABLE `tbl_kettle_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL DEFAULT '',
  `quantity_in_ltrs` float unsigned NOT NULL DEFAULT '0',
  `rate` float unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `tbl_kettle_types` WRITE;
/*!40000 ALTER TABLE `tbl_kettle_types` DISABLE KEYS */;

INSERT INTO `tbl_kettle_types` (`id`, `name`, `quantity_in_ltrs`, `rate`)
VALUES
	(1,'_18_ltrs_',18,20);

/*!40000 ALTER TABLE `tbl_kettle_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table tbl_needs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_needs`;

CREATE TABLE `tbl_needs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) unsigned NOT NULL,
  `kettle_id` int(11) unsigned NOT NULL,
  `num_of_kettles` int(4) unsigned NOT NULL DEFAULT '1',
  `rate_per_kettle` double unsigned NOT NULL DEFAULT '1',
  `day_to_deliver` enum('SUNDAY','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY') NOT NULL DEFAULT 'MONDAY',
  `need_type` enum('ONCE','RECURRENT') NOT NULL DEFAULT 'ONCE',
  `status` enum('ENABLED','DISABLED') NOT NULL DEFAULT 'ENABLED',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_customer_id_tbl_customer_tbl_needs` (`customer_id`),
  KEY `fk_kettle_id_tbl_kettle_types_tbl_needs` (`kettle_id`),
  CONSTRAINT `fk_customer_id_tbl_customer_tbl_needs` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer_details` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_kettle_id_tbl_kettle_types_tbl_needs` FOREIGN KEY (`kettle_id`) REFERENCES `tbl_kettle_types` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table tbl_orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_orders`;

CREATE TABLE `tbl_orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) unsigned NOT NULL,
  `need_id` int(11) unsigned NOT NULL,
  `kettle_type` int(11) unsigned NOT NULL,
  `number_of_kettles` int(4) unsigned DEFAULT '1',
  `order_status` enum('PENDING','DELIVERED','DELETED') NOT NULL DEFAULT 'PENDING',
  `total_amount` float unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_need_id_tbl_needs_tbl_orders` (`need_id`),
  KEY `fk_customer_id_tbl_customer_details_tbl_orders` (`customer_id`),
  CONSTRAINT `fk_customer_id_tbl_customer_details_tbl_orders` FOREIGN KEY (`customer_id`) REFERENCES `tbl_customer_details` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `fk_need_id_tbl_needs_tbl_orders` FOREIGN KEY (`need_id`) REFERENCES `tbl_needs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `tr_update_tbl_needs_status_insert_tbl_pending_payments` AFTER UPDATE ON `tbl_orders` FOR EACH ROW BEGIN
    IF NEW.order_status = 'DELIVERED' THEN
      UPDATE tbl_needs
      SET STATUS = 'DISABLED'
      WHERE STATUS = 'ENABLED'
      AND need_type = 'ONCE'
      AND id = NEW.need_id
      AND customer_id = NEW.customer_id;

      INSERT INTO tbl_pending_payments
      SET order_id=NEW.id,
      money_pending=NEW.total_amount,
      created_at=NOW(),
      modified_at=NOW();
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


# Dump of table tbl_pending_payments
# ------------------------------------------------------------

DROP TABLE IF EXISTS `tbl_pending_payments`;

CREATE TABLE `tbl_pending_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) unsigned NOT NULL,
  `money_pending` float unsigned NOT NULL DEFAULT '0',
  `amount_paid` float unsigned NOT NULL DEFAULT '0',
  `status` enum('PAID','PENDING','PARTIALLY_PAID') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_order_id_tbl_order_tbl_pending_payments` (`order_id`),
  CONSTRAINT `fk_order_id_tbl_order_tbl_pending_payments` FOREIGN KEY (`order_id`) REFERENCES `tbl_orders` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50017 DEFINER=`root`@`localhost` */ /*!50003 TRIGGER `tr_update_tbl_pending_payments_insert_tbl_complete_payments` BEFORE UPDATE ON `tbl_pending_payments` FOR EACH ROW IF NEW.amount_paid > 0 AND NEW.amount_paid > OLD.amount_paid AND OLD.status <> 'PAID' THEN

  IF NEW.amount_paid <> NEW.money_pending THEN
  	SET NEW.status = "PARTIALLY_PAID";
  ELSE
  	SET NEW.status = "PAID";
  END IF;

   IF NEW.status = 'PARTIALLY_PAID' OR OLD.status = 'PARTIALLY_PAID' THEN
   	 SET @is_partial = 'YES';
   ELSE
     SET @is_partial = 'NO';
   END IF;

  INSERT INTO  tbl_complete_payments
  SET order_id = NEW.order_id,
  amount_paid = NEW.amount_paid - OLD.amount_paid,
  is_partial = @is_partial,
  created_at = NOW(),
  modified_at = NOW();
END IF */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
