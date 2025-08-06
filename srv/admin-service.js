const cds = require('@sap/cds');
const { INSERT, SELECT } = cds.ql;

module.exports = cds.service.impl(function () {
  const { Returns } = this.entities;

  this.before(['CREATE', 'UPDATE'], 'Books', (req) => {
    if (req.event === 'CREATE' && !req.data.ID) {
      req.data.ID = cds.utils.uuid();
    }
    if (req.data.price !== undefined) {
      const value = typeof req.data.price === 'string' ? parseFloat(req.data.price) : req.data.price;
      if (!Number.isNaN(value)) req.data.price = value;
    }
  });

  this.on('contact', 'Customers', async (req) => {
    const { subject, message } = req.data;
    const { ID } = req.params[0];
    console.log(`Contacting customer ${ID}: ${subject} - ${message}`);
    return 'Message sent';
  });

  this.on('requestReturn', 'OrderItems', async (req) => {
    const { reason } = req.data;
    const { parent_ID, lineNo } = req.params[0];
    const ID = cds.utils.uuid();
    await INSERT.into(Returns).entries({
      ID,
      orderItem_parent_ID: parent_ID,
      orderItem_lineNo: lineNo,
      reason,
      status: 'REQUESTED'
    });
    return SELECT.one.from(Returns).where({ ID });
  });
});
