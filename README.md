# 🧠 Datalake Infrastructure for **The Band**

This repository sets up a **Dremio-based Datalake infrastructure** to support data integration and exploration for *The Band* project. It leverages **Ontology Data Repositories (ODRs)** to unify and expose data for stakeholders through semantic-aware queries.

## 🏗️ Build Setup

First, create a `.env` file at the root of the project with the following content:

```env
DREMIO_IMAGE_VERSION=latest
```

Then, build the Docker containers with:

```bash
docker compose build
```

## 🚀 Running the Environment

Start the infrastructure using Docker Compose:

```bash
docker compose up -d
```

This command will launch Dremio and any supporting services defined in the `docker-compose.yml`.

## 📊 Semantic Queries

We’ve developed a set of semantic queries using *The Band*’s Ontology Data Repositories (ODRs). These queries provide integrated, meaningful insights to stakeholders and support analytical tools like **Zeppelin**.

- 📘 [Zeppelin Queries](./zeppelin_queries.md) — A collection of prepared queries aligned with specific assessment scenarios.

These queries are designed to:
- Integrate diverse datasets through ontology alignment
- Deliver domain-specific insights
- Support decision-making based on unified data views

---

## 🧩 Components

| Component | Description |
|----------|-------------|
| **Dremio** | Acts as the semantic data lake engine, connecting multiple sources and exposing integrated datasets |
| **ODR** | Ontology-driven data repositories that semantically organize domain data |

---

## 📚 Resources

- [Dremio Documentation](https://docs.dremio.com/)
