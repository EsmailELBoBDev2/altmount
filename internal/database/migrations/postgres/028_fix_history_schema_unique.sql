-- +goose Up
-- +goose StatementBegin
ALTER TABLE import_history DROP CONSTRAINT IF EXISTS import_history_download_id_virtual_path_key;
ALTER TABLE import_history ADD CONSTRAINT import_history_download_id_virtual_path_key UNIQUE (download_id, virtual_path);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE import_history DROP CONSTRAINT IF EXISTS import_history_download_id_virtual_path_key;
-- +goose StatementEnd