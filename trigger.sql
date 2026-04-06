CREATE OR REPLACE FUNCTION sync_quantity()
    RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE "group"
        SET quantity = quantity + 1
        WHERE id = NEW.group_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE "group"
        SET quantity = quantity - 1
        WHERE id = OLD.group_id;
    ELSIF (TG_OP = 'UPDATE') THEN
        IF (NEW.group_id <> OLD.group_id) THEN
            UPDATE "group"
            SET quantity = quantity + 1
            WHERE id = NEW.group_id;

            UPDATE "group"
            SET quantity = quantity - 1
            WHERE id = OLD.group_id;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_inventors
    AFTER INSERT OR UPDATE OR DELETE ON main_inventor_of_group
    FOR EACH ROW
EXECUTE FUNCTION sync_quantity();