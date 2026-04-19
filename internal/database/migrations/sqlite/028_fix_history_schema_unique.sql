-- +goose Up
-- +goose StatementBegin
-- SQLite doesn't support ALTER TABLE ADD CONSTRAINT. We must recreate the table.
CREATE TABLE import_history_new (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    download_id TEXT DEFAULT NULL,
    nzb_id INTEGER,
    nzb_name TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT,
    virtual_path TEXT NOT NULL,
    category TEXT,
    metadata TEXT DEFAULT NULL,
    instance_name TEXT DEFAULT NULL,
    status TEXT NOT NULL DEFAULT 'completed',
    completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(download_id, virtual_path)
);

-- Copy data, prioritizing records with a download_id if duplicates exist
INSERT OR IGNORE INTO import_history_new (
    id, download_id, nzb_id, nzb_name, file_name, file_size, 
    virtual_path, category, metadata, instance_name, status, completed_at
) SELECT 
    id, download_id, nzb_id, nzb_name, file_name, file_size, 
    virtual_path, category, metadata, instance_name, status, completed_at
FROM import_history 
ORDER BY download_id DESC, status DESC; -- Prioritize completed over grabbed

DROP TABLE import_history;
ALTER TABLE import_history_new RENAME TO import_history;

-- Restore indexes
CREATE INDEX idx_import_history_download_id ON import_history(download_id);
CREATE INDEX idx_import_history_completed ON import_history(completed_at DESC);
CREATE INDEX idx_import_history_file_name ON import_history(file_name);
CREATE INDEX idx_import_history_status ON import_history(status);
CREATE INDEX idx_import_history_instance ON import_history(instance_name);
CREATE INDEX idx_import_history_virtual_path ON import_history(virtual_path);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- Down migration omitted for safety
-- +goose StatementEnd
