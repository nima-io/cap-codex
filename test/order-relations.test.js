"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_test_1 = __importDefault(require("node:test"));
const strict_1 = __importDefault(require("node:assert/strict"));
const cds_1 = __importDefault(require("@sap/cds"));
const { GET, POST } = cds_1.default.test(__dirname + '/..');
(0, node_test_1.default)('creating order item updates stock and author totals', async () => {
    const bookID = '9c8df99a-7759-4476-b248-509fdd5a7d00';
    const authorID = '98bc6893-e48c-46d9-80db-7c5e2cb0abae';
    const customerID = '46e1f4a1-673f-41de-beb1-5a4cc0b41b61';
    let res = await POST('/odata/v4/admin/Orders', {
        customer_ID: customerID,
        IsActiveEntity: true,
    });
    strict_1.default.equal(res.status, 201);
    const orderID = res.data.ID;
    res = await POST('/odata/v4/admin/OrderItems', {
        parent_ID: orderID,
        lineNo: 1,
        book_ID: bookID,
        quantity: 2,
        IsActiveEntity: true,
    });
    strict_1.default.equal(res.status, 201);
    res = await GET(`/odata/v4/admin/OrderItems(parent_ID=${orderID},lineNo=1,IsActiveEntity=true)`);
    strict_1.default.equal(Number(res.data.netAmount).toFixed(2), '39.80');
    res = await GET(`/odata/v4/admin/Books(ID=${bookID},IsActiveEntity=true)`);
    strict_1.default.equal(res.data.stock, 10);
    res = await GET(`/odata/v4/admin/Authors(ID=${authorID},IsActiveEntity=true)`);
    strict_1.default.equal(Number(res.data.totalSales).toFixed(2), '1039.80');
    strict_1.default.equal(Number(res.data.totalRoyalty).toFixed(2), '103.98');
});
