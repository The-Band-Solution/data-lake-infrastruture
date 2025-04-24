# Datalake infrastruture to The Band
Dremio - Provides a datalake infrastruture to The Band.
## Build

First, create a .env file with the contain: 

```
DREMIO_IMAGE_VERSION=latest
```

Then, execute the following command in a terminal:

```bash
docker compose build
```

## Usage

Execute the following command in a terminal:

```bash
docker compose up -d 
```

## Query

We develop a set of queries that uses *The Band*`s Ontology Data Repositories (ODR) to provides integrated data to a stakeholder.

* [Zeppelin Queries](./zeppelin_queries.md): provide integrated data to answser some Zeppelìn`s assessment;


