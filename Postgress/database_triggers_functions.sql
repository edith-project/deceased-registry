CREATE TRIGGER convert_duration AFTER INSERT ON followup 
FOR EACH ROW PROCEDURE convert_duration_to_days();

CREATE OR REPLACE FUNCTION convert_duration_to_days() 
	RETURNS TRIGGER AS 
$BODY$
BEGIN
    UPDATE INTO followup(days_tx_event)
	VALUES (SELECT SUBSTRING (days_tx_event,'\d') as days);
END;
$BODY$