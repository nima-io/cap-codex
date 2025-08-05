const test = require('node:test');
const assert = require('node:assert/strict');
const cds = require('@sap/cds');

test('admin app serves non-empty content', async () => {
  const srv = await cds.test(__dirname + '/..');
  const res = await fetch(`${srv.url}/admin/`);
  const text = await res.text();
  assert.equal(res.status, 200);
  assert.notEqual(text.trim(), '');
  assert.match(text, /<title>Admin<\/title>/);
  await srv.server.close();
});
