-- +goose Up
-- +goose StatementBegin
ALTER TABLE import_history ADD COLUMN status TEXT NOT NULL DEFAULT 'completed';
ALTER TABLE import_history ADD COLUMN metadata TEXT DEFAULT NULL;
ALTER TABLE import_history ADD COLUMN instance_name TEXT DEFAULT NULL;

CREATE INDEX IF NOT EXISTS idx_history_status ON import_history(status);
CREATE INDEX IF NOT EXISTS idx_history_instance ON import_history(instance_name);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_history_instance;
DROP INDEX IF EXISTS idx_history_status;
-- +goose StatementEnd
