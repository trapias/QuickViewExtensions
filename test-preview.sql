-- Test easySQLView
-- Schema for QuickViewExtensions analytics

CREATE TABLE IF NOT EXISTS extensions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(200) NOT NULL,
    uti_type VARCHAR(255) NOT NULL,
    file_extensions TEXT[] NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS preview_events (
    id BIGSERIAL PRIMARY KEY,
    extension_id INTEGER REFERENCES extensions(id),
    file_path TEXT NOT NULL,
    file_size_bytes BIGINT,
    render_time_ms INTEGER,
    dark_mode BOOLEAN,
    success BOOLEAN DEFAULT true,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert extensions
INSERT INTO extensions (name, display_name, uti_type, file_extensions) VALUES
    ('easyMDView', 'Markdown Viewer', 'net.daringfireball.markdown', ARRAY['.md']),
    ('easyJSONView', 'JSON Viewer', 'public.json', ARRAY['.json']),
    ('easyCodeView', 'Code Viewer', 'public.source-code', ARRAY['.swift', '.py', '.js', '.ts', '.cs']),
    ('easyYAMLView', 'YAML Viewer', 'public.yaml', ARRAY['.yaml', '.yml']),
    ('easyDotEnvView', 'DotEnv Viewer', 'com.albertopasca.dotenv', ARRAY['.env']),
    ('easyLogView', 'Log Viewer', 'com.apple.log', ARRAY['.log']),
    ('easySQLView', 'SQL Viewer', 'com.albertopasca.sql', ARRAY['.sql'])
ON CONFLICT (name) DO UPDATE SET updated_at = NOW();

-- Analytics query
SELECT
    e.display_name,
    COUNT(pe.id) AS total_previews,
    AVG(pe.render_time_ms) AS avg_render_ms,
    SUM(CASE WHEN pe.success THEN 1 ELSE 0 END) AS successful,
    SUM(CASE WHEN NOT pe.success THEN 1 ELSE 0 END) AS failed
FROM extensions e
LEFT JOIN preview_events pe ON e.id = pe.extension_id
WHERE pe.created_at >= NOW() - INTERVAL '7 days'
GROUP BY e.display_name
ORDER BY total_previews DESC;

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_preview_events_created_at
    ON preview_events (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_preview_events_extension_id
    ON preview_events (extension_id);
