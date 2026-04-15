CREATE OR REPLACE FUNCTION notice_success_discovery()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.success_id IS NOT NULL AND EXISTS (
        SELECT 1
        FROM success
        WHERE (id = NEW.success_id) AND (metric_percentage > 80)
    ) THEN
        RAISE NOTICE 'Совершено невероятно успешное открытие!!!!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_successful_discovery
    BEFORE INSERT OR UPDATE ON discovery
    FOR EACH ROW
EXECUTE FUNCTION notice_success_discovery();