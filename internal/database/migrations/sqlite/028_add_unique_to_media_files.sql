-- +goose Up
-- +goose StatementBegin
CREATE TABLE media_files_new (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    instance_name TEXT NOT NULL,
    instance_type TEXT NOT NULL CHECK(instance_type IN ('radarr', 'sonarr', 'lidarr', 'readarr', 'whisparr')),
    external_id INTEGER NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    file_id INTEGER,
    UNIQUE(instance_name, instance_type, external_id)
);

INSERT OR IGNORE INTO media_files_new SELECT id, instance_name, instance_type, external_id, file_path, file_size, created_at, updated_at, file_id FROM media_files;

DROP TABLE media_files;
ALTER TABLE media_files_new RENAME TO media_files;

CREATE INDEX idx_media_files_file_path ON media_files(file_path);
CREATE INDEX idx_media_files_instance ON media_files(instance_name, instance_type);
CREATE INDEX idx_media_files_external ON media_files(instance_name, instance_type, external_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
-- Not strictly necessary, but for reversal:
CREATE TABLE media_files_old (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    instance_name TEXT NOT NULL,
    instance_type TEXT NOT NULL CHECK(instance_type IN ('radarr', 'sonarr', 'lidarr', 'readarr', 'whisparr')),
    external_id INTEGER NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    file_id INTEGER
);
INSERT INTO media_files_old SELECT * FROM media_files;
DROP TABLE media_files;
ALTER TABLE media_files_old RENAME TO media_files;
-- +goose StatementEnd
