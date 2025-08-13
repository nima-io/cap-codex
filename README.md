# cap-codex

A simple CAP project for experimenting with the SAP Cloud Application Programming Model.

## Sample Data

Mock data for a sample bookshop is available in `db/data` and includes authors, books,
customers, orders and order items for local viewing and testing.

## Running

Install dependencies and start the service:

```
npm install
npm start
```

Once running, browse the OData V4 service at <http://localhost:4004/odata/v4/admin/> to view authors, books, customers, orders and order items.
All entities in this service support the OData draft protocol for managing edits.
