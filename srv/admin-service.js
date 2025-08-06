const cds = require('@sap/cds');

module.exports = cds.service.impl(function () {
  this.before(['CREATE', 'UPDATE'], 'Books', (req) => {
    if (req.data.price !== undefined) {
      const value = typeof req.data.price === 'string' ? parseFloat(req.data.price) : req.data.price;
      if (!Number.isNaN(value)) req.data.price = value;
    }
  });
});
