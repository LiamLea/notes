# PostgreSQL

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [PostgreSQL](#postgresql)
    - [Requirements](#requirements)
      - [1.lineage and usage from `pg_stat_statements`](#1lineage-and-usage-from-pg_stat_statements)
      - [2.config yaml](#2config-yaml)
      - [3.demo](#3demo)

<!-- /code_chunk_output -->


### Requirements

#### 1.lineage and usage from `pg_stat_statements`

* enable `pg_stat_statements`
```sql
CREATE EXTENSION pg_stat_statements;
ALTER SYSTEM SET pg_stat_statements.track = 'all';
```
* grant permission
```sql
GRANT pg_read_all_stats TO <your_user>;
```

#### 2.config yaml
[demo](https://docs.open-metadata.org/v1.12.x/connectors/database/postgres/yaml)
[config](https://github.com/open-metadata/OpenMetadata/blob/main/openmetadata-spec/src/main/resources/json/schema/entity/services/connections/database/postgresConnection.json)

#### 3.demo
```python
import os
import yaml

from metadata.workflow.metadata import MetadataWorkflow



CONFIG = f"""
source:
  type: postgres
  serviceName: {os.getenv('SERVICE_NAME')}
  serviceConnection:
    config:
      type: Postgres
      username: {os.getenv('POSTGRES_USERNAME')}
      authType:
        awsConfig:
          awsAccessKeyId: {os.getenv('AWS_ACCESS_KEY_ID')}
          awsSecretAccessKey: {os.getenv('AWS_SECRET_ACCESS_KEY')}
          awsSessionToken: {os.getenv('AWS_SESSION_TOKEN')}
          awsRegion: {os.getenv('AWS_REGION')}
      hostPort: {os.getenv('HOST_PORT')}
      database: postgres
      ingestAllDatabases: true
      sslMode: require
  sourceConfig:
    config:
      type: DatabaseMetadata
      markDeletedTables: true
      markDeletedStoredProcedures: true
      markDeletedSchemas: true
      markDeletedDatabases: true
      includeTables: true
      includeViews: true
      databaseFilterPattern:
        includes: {os.getenv('DATABASES').split(',')}
      schemaFilterPattern:
        includes:
        - public
sink:
  type: metadata-rest
  config: {{}}
workflowConfig:
  loggerLevel: INFO  # DEBUG, INFO, WARNING or ERROR
  openMetadataServerConfig:
    hostPort: {os.getenv('OPEN_METADATA_URL').strip('/')}/api
    authProvider: openmetadata
    securityConfig:
      jwtToken: {os.getenv('OPEN_METADATA_INJESTION_TOKEN')}
    ## Store the service Connection information
    storeServiceConnection: true  # false
"""


def run():
    workflow_config = yaml.safe_load(CONFIG)
    workflow = MetadataWorkflow.create(workflow_config)
    workflow.execute()
    workflow.raise_from_status()
    workflow.print_status()
    workflow.stop()


if __name__ == "__main__":
    run()
```