# schema association

[toc]

### Overview

* Link a data file (json/yaml) to a **JSON Schema**
* The editor then gives **autocomplete, validation and hover hints**
* yaml uses JSON Schema too

### How to associate

#### 1.In the file

* json: `$schema` field
```json
{
  "$schema": "https://json.schemastore.org/package.json",
  "name": "demo"
}
```

* yaml: a comment (needs yaml-language-server, e.g. the VS Code YAML extension)
```yaml
# yaml-language-server: $schema=https://json.schemastore.org/github-workflow.json
name: ci
```

#### 2.In editor settings (VS Code `settings.json`)

* Match by file name, no change to the data file
```json
{
  "json.schemas": [
    { "fileMatch": ["config/*.json"], "url": "./schemas/config.schema.json" }
  ],
  "yaml.schemas": {
    "./schemas/config.schema.json": "config/*.yaml"
  }
}
```

#### 3.Automatic (SchemaStore)

* [SchemaStore](https://www.schemastore.org/) has schemas for common files (`package.json`, `docker-compose.yml`, `.github/workflows/*.yml`)
* The editor associates them by file name, no setup needed
