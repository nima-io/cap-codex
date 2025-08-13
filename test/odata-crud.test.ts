import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET, POST, PATCH, DELETE } = cds.test(__dirname + '/..');

test('OData CRUD operations for Books entity', async () => {
  const newBook = {
    title: 'Test Book',
    stock: 5,
    price: '11.99',
    author_ID: '98bc6893-e48c-46d9-80db-7c5e2cb0abae',
    publisher_ID: '11111111-1111-1111-1111-111111111111',
    category_ID: '33333333-3333-3333-3333-333333333333',
    format_ID: '55555555-5555-5555-5555-555555555555',
    IsActiveEntity: true,
  };

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

  // Update general and classification information
  res = await PATCH(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`, {
    stock: 7,
    price: '10.50',
    title: 'Updated Book',
    author_ID: '0228ee7a-7cae-41ee-b33b-91746536e33c',
    category_ID: '44444444-4444-4444-4444-444444444444'
  });
  assert.equal(res.status, 200);
  res = await GET(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`);
  assert.equal(res.data.title, 'Updated Book');
  assert.equal(res.data.stock, 7);
  assert.equal(Number(res.data.price), 10.5);
  assert.equal(res.data.author_ID, '0228ee7a-7cae-41ee-b33b-91746536e33c');
  assert.equal(res.data.category_ID, '44444444-4444-4444-4444-444444444444');

  // Delete
  res = await DELETE(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`);
  assert.equal(res.status, 204);

  // Ensure deletion
  res = await GET(`/odata/v4/admin/Books(ID=${id},IsActiveEntity=true)`).catch(err => err.response);
  assert.equal(res.status, 404);
});
