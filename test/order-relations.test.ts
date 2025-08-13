import test from 'node:test';
import assert from 'node:assert/strict';
import cds from '@sap/cds';

const { GET, POST } = cds.test(__dirname + '/..');

test('creating order item updates stock and author totals', async () => {
  const bookID = '9c8df99a-7759-4476-b248-509fdd5a7d00';
  const authorID = '98bc6893-e48c-46d9-80db-7c5e2cb0abae';
  const customerID = '46e1f4a1-673f-41de-beb1-5a4cc0b41b61';

  let res = await POST('/odata/v4/admin/Orders', {
    customer_ID: customerID,
    IsActiveEntity: true,
  });
  assert.equal(res.status, 201);
  const orderID = res.data.ID;

  res = await POST('/odata/v4/admin/OrderItems', {
    parent_ID: orderID,
    lineNo: 1,
    book_ID: bookID,
    quantity: 2,
    IsActiveEntity: true,
  });
  assert.equal(res.status, 201);

  res = await GET(
    `/odata/v4/admin/OrderItems(parent_ID=${orderID},lineNo=1,IsActiveEntity=true)`
  );
  assert.equal(Number(res.data.netAmount).toFixed(2), '39.80');

  res = await GET(`/odata/v4/admin/Books(ID=${bookID},IsActiveEntity=true)`);
  assert.equal(res.data.stock, 10);

  res = await GET(
    `/odata/v4/admin/Authors(ID=${authorID},IsActiveEntity=true)`
  );
  assert.equal(Number(res.data.totalSales).toFixed(2), '1039.80');
  assert.equal(Number(res.data.totalRoyalty).toFixed(2), '103.98');
});

