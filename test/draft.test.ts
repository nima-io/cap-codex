import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET, PATCH } = cds.test(__dirname + '/..');

test('Books entity is draft enabled', async () => {
  const res = await GET('/odata/v4/admin/Books?$top=1');
  assert.equal(res.status, 200);
  assert.ok('IsActiveEntity' in res.data.value[0]);
});

test('Books allow direct updates with draft bypass', async () => {
  let res = await GET('/odata/v4/admin/Books?$top=1');
  assert.equal(res.status, 200);
  const book = res.data.value[0];
  const newPrice = Number(book.price) + 1;
  res = await PATCH(`/odata/v4/admin/Books(ID=${book.ID},IsActiveEntity=true)`, { price: String(newPrice) });
  assert.equal(res.status, 200);
  res = await GET(`/odata/v4/admin/Books(ID=${book.ID},IsActiveEntity=true)`);
  assert.equal(Number(res.data.price), newPrice);
});
