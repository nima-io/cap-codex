# AGENTS.md — Project Guidelines for AI Agents and Developers

## Purpose

This document provides AI agents (e.g., OpenAI Codex) and developers with **clear instructions** on how to work with this SAP CAP project.
It defines:

* Project structure and conventions
* Development & deployment commands
* Coding & security standards
* Testing requirements
* Common pitfalls and solutions

---

## 1. Tech Stack

* **Framework:** SAP Cloud Application Programming Model (CAP)
* **Runtime:** Node.js (TypeScript)
* **Database:** SQLite (local), SAP HANA Cloud (production)
* **UI:** SAPUI5 / Fiori (optional, in `/app` folder)
* **Deployment:** SAP Business Technology Platform (BTP) — Cloud Foundry

---

## 2. Project Structure

```
/db       → CDS domain models, schema, and seed data (CSV)
/srv      → Service implementations (TypeScript/JavaScript)
/app      → UI modules (e.g., UI5/Fiori), `webapp` folder inside each UI module
/test     → Unit and integration tests
/config   → Config files (ESLint, Jest, default-env.json)
```

**Key files:**

* `package.json` — npm scripts and dependencies
* `cds.env` — CAP configuration
* `.env` — environment variables (DO NOT commit to git)
* `mta.yaml` — multi-target application configuration for CF deployment

---

## 3. Setup & Development

**Local (SQLite):**

```bash
npm install
npm run build         # Compile TypeScript → JavaScript
npm run dev           # Start CAP server in watch mode
```

**With HANA (BTP Cloud Foundry):**

```bash
npm run build
npm run hana:deploy   # cds deploy --to hana
npm run cf:push       # Deploy to Cloud Foundry
```

---

## 4. Available npm Scripts

* `npm run dev` — Start CAP server with hot reload
* `npm run build` — Compile TypeScript
* `npm run lint` — Run ESLint
* `npm run fmt` — Format code with Prettier
* `npm test` — Run tests (Jest)
* `npm run cds:compile` — Compile CDS to CSN/OData
* `npm run seed` — Load seed data from `/db/data`

> **Agent rule:** Always use these npm scripts instead of raw commands.

---

## 5. Service Information

* **Main OData Endpoint:** `/odata/v4/`
* **Example service:** `srv/admin-service.cds`

  * Entities: `Books`, `Authors`
* **Sample Requests:**

  * `GET /odata/v4/admin/Books?$expand=author`
  * `POST /odata/v4/admin/Books` (payload schema defined in `db/schema.cds`)

---

## 6. Coding Guidelines

* Use **TypeScript** (strict mode, no `any`)
* Prefer `async/await` over `.then()`
* Handle errors with structured objects:

  ```ts
  throw { code: 'BAD_REQUEST', message: 'Invalid input' }
  ```
* Follow CAP handler signature:

  ```ts
  this.on('READ', 'Books', async (req, next) => { ... })
  ```
* **Security:** Never hardcode secrets. Use `process.env` variables.
* Use CAP annotations for authorization: `@restrict`, `@requires`.
* Keep UI text in `i18n` files.

---

## 7. Testing

* **Framework:** Jest
* **Run:** `npm test`
* If you modify code, **update or add corresponding tests** in `/test`.
* Pull requests will not be merged unless tests pass.

---

## 8. Data & Migrations

* **Default database:** SQLite (`sqlite.db`)
* **Seed data:** `/db/data/*.csv`
* For HANA: Use `cds deploy --to hana` and HDI containers
* Avoid committing large CSV files.

---

## 9. Deployment Instructions

**To BTP/CF:**

```bash
npm run build
mbt build
cf deploy mta_archives/*.mtar
```

**Required Services:**

* `hana` — SAP HANA Cloud
* `xsuaa` — Authentication/Authorization
* Optional: `destination`, `html5-apps-repo`

---

## 10. Pull Request Rules

* Branch naming: `feat/...`, `fix/...`, `chore/...`
* Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
* Before PR:

  * Lint passes
  * Tests pass
  * Documentation updated if needed

---

## 11. Agent Do’s & Don’ts

✅ **Do:**

* Use npm scripts for build/test/deploy
* Follow coding style and folder structure
* Create/update tests when adding features

❌ **Do NOT:**

* Push secrets (`.env`, `default-env.json`)
* Force push to `main`
* Break entity schemas without migration steps

---

## 12. Common Issues & Solutions

* **HDI Deployment fails:** Check `cf logs <app> --recent`; ensure service bindings are correct.
* **OData `$expand` errors:** Review entity associations and annotations.
* **CORS/UI issues in UI5:** Check CAP `cds.env.requires.auth` and CORS settings.

---

## 13. Contacts & Ownership

* Code owners: `@cap-core-team`
* Architecture documentation: `/docs/architecture.md`
* On-call channel: `#cap-support`

---

*End of AGENTS.md*
