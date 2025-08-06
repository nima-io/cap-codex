const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');
const { randomUUID } = require('node:crypto');

const { GET, POST, PATCH, DELETE } = cds.test(__dirname + '/..');

test('OData CRUD operations for Books entity', async () => {
  const id = randomUUID();
  const newBook = { ID: id, title: 'Test Book', stock: 5, price: '11.99' };

  // Create
  let res = await POST(`/odata/v4/catalog/Books`, newBook);
  assert.equal(res.status, 201);

  // Read
  res = await GET(`/odata/v4/catalog/Books(${id})`);
  assert.equal(res.status, 200);
  assert.equal(res.data.ID, id);
  assert.equal(Number(res.data.price), 11.99);

  // Update
  res = await PATCH(`/odata/v4/catalog/Books(${id})`, { stock: 7, price: '10.50' });
  assert.equal(res.status, 200);
  res = await GET(`/odata/v4/catalog/Books(${id})`);
  assert.equal(res.data.stock, 7);
  assert.equal(Number(res.data.price), 10.5);

  // Delete
  res = await DELETE(`/odata/v4/catalog/Books(${id})`);
  assert.equal(res.status, 204);

  // Ensure deletion
  res = await GET(`/odata/v4/catalog/Books(${id})`).catch(err => err.response);
  assert.equal(res.status, 404);
});
