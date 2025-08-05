const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');

const { GET, POST, PATCH, DELETE } = cds.test(__dirname + '/..');

test('AdminService CRUD operations for Books entity', async () => {
  const newBook = { title: 'Admin Test Book', stock: 3, price: 10.99, IsActiveEntity: true };

  // Create without specifying ID
  let res = await POST(`/odata/v4/admin/Books`, newBook);
  assert.equal(res.status, 201);
  const { ID } = res.data;
  assert.ok(ID, 'ID should be generated');
  const key = `ID=${ID},IsActiveEntity=true`;

  // Read
  res = await GET(`/odata/v4/admin/Books(${key})`);
  assert.equal(res.status, 200);
  assert.equal(res.data.title, newBook.title);

  // Update
  res = await PATCH(`/odata/v4/admin/Books(${key})`, { stock: 5 });
  assert.equal(res.status, 200);
  res = await GET(`/odata/v4/admin/Books(${key})`);
  assert.equal(res.data.stock, 5);

  // Delete
  res = await DELETE(`/odata/v4/admin/Books(${key})`);
  assert.equal(res.status, 204);

  // Ensure deletion
  res = await GET(`/odata/v4/admin/Books(${key})`).catch(err => err.response);
  assert.equal(res.status, 404);
});
