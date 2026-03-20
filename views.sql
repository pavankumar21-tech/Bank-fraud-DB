DELIMITER //

DROP TRIGGER IF EXISTS fraud_detection_trigger //

CREATE TRIGGER fraud_detection_trigger
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE recent_count INT;
    DECLARE avg_last_30_days DECIMAL(12,2) DEFAULT 0;
    
    IF NEW.amount > 50000 THEN
        INSERT INTO fraud_alerts (transaction_id, reason, severity)
        VALUES (NEW.transaction_id, 'Extremely high transaction amount (>50,000)', 'CRITICAL');
    END IF;
    
    SELECT COUNT(*) INTO recent_count
    FROM transactions
    WHERE account_id = NEW.account_id
      AND transaction_time >= NEW.transaction_time - INTERVAL 10 MINUTE
      AND transaction_id != NEW.transaction_id;
    
    IF recent_count >= 5 THEN
        INSERT INTO fraud_alerts (transaction_id, reason, severity)
        VALUES (NEW.transaction_id, 'High velocity: 5+ tx in 10 minutes', 'HIGH');
    END IF;
    
    IF HOUR(NEW.transaction_time) BETWEEN 0 AND 5 AND NEW.amount > 10000 THEN
        INSERT INTO fraud_alerts (transaction_id, reason, severity)
        VALUES (NEW.transaction_id, 'High value transaction in unusual night hours (00-05)', 'HIGH');
    END IF;
    
    SELECT COALESCE(AVG(amount), 0) INTO avg_last_30_days
    FROM transactions
    WHERE account_id = NEW.account_id
      AND transaction_time < NEW.transaction_time
      AND transaction_time >= NEW.transaction_time - INTERVAL 30 DAY;
    
    IF avg_last_30_days > 0 AND NEW.amount > avg_last_30_days * 5 THEN
        INSERT INTO fraud_alerts (transaction_id, reason, severity)
        VALUES (NEW.transaction_id, 'Sudden amount spike (>5x 30-day average)', 'MEDIUM');
    END IF;
    
END //

DELIMITER ;