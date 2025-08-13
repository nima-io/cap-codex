import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET } = cds.test(__dirname + '/..');

test('BookTags entity is readable', async () => {
  const res = await GET('/odata/v4/admin/BookTags?$top=1');
  assert.equal(res.status, 200);
  assert.ok(Array.isArray(res.data.value));
  assert.ok(res.data.value.length >= 1);
  const entry = res.data.value[0];
  assert.ok(entry.book_ID);
  assert.ok(entry.tag_ID);
});
