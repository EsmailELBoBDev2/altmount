-- +goose Up
-- +goose StatementBegin
ALTER TABLE file_health ADD COLUMN download_id TEXT DEFAULT NULL;
CREATE INDEX IF NOT EXISTS idx_health_download_id ON file_health(download_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_health_download_id;
-- +goose StatementEnd
