-- +goose Up
-- +goose StatementBegin
ALTER TABLE import_queue ADD COLUMN instance_name TEXT DEFAULT NULL;
CREATE INDEX IF NOT EXISTS idx_queue_instance_name ON import_queue(instance_name);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_queue_instance_name;
-- +goose StatementEnd
