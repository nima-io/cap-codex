import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET, POST, PATCH, DELETE } = cds.test(__dirname + '/..');

test('OData CRUD operations for Books entity', async () => {
  const newBook = { title: 'Test Book', stock: 5, price: '11.99', IsActiveEntity: true };

  // Create without specifying ID to allow backend to generate one
  let res = await POST(`/odata/v4/admin/Books`, newBook);
  assert.equal(res.status, 201);
  const id = res.data.ID;
  assert.ok(id);

  // Read
  res = await GET(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`);
  assert.equal(res.status, 200);
  assert.equal(res.data.ID, id);
  assert.equal(res.data.IsActiveEntity, true);
  assert.equal(Number(res.data.price), 11.99);

  // Update
  res = await PATCH(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`, { stock: 7, price: '10.50' });
  assert.equal(res.status, 200);
  res = await GET(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`);
  assert.equal(res.data.stock, 7);
  assert.equal(Number(res.data.price), 10.5);

  // Delete
  res = await DELETE(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`);
  assert.equal(res.status, 204);

  // Ensure deletion
  res = await GET(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`).catch(err => err.response);
  assert.equal(res.status, 404);
});
