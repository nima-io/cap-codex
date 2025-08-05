const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');

const { GET } = cds.test(__dirname + '/..');

test('Books entity is draft enabled', async () => {
  const res = await GET('/odata/v4/admin/Books?$top=1');
  assert.equal(res.status, 200);
  assert.ok('IsActiveEntity' in res.data.value[0]);
});
