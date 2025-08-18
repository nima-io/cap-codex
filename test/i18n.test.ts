import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET, POST } = cds.test(__dirname + '/..');

test('contact action is localized', async () => {
  let res = await GET('/odata/v4/admin/Customers?$top=1');
  assert.equal(res.status, 200);
  const id = res.data.value[0].ID;

  res = await POST(
    `/odata/v4/admin/Customers(ID=${id},IsActiveEntity=true)/contact`,
    { subject: 'Hi', message: 'Test' },
    { headers: { 'Accept-Language': 'de' } }
  );
  assert.equal(res.status, 200);
  assert.equal(res.data.value, 'Nachricht gesendet');

  res = await POST(
    `/odata/v4/admin/Customers(ID=${id},IsActiveEntity=true)/contact`,
    { subject: 'Hi', message: 'Test' },
    { headers: { 'Accept-Language': 'en' } }
  );
  assert.equal(res.status, 200);
  assert.equal(res.data.value, 'Message sent');
});
