import cds, { Request, Service } from "@sap/cds";
const { INSERT, SELECT } = cds.ql;

/**
 * Service handlers for administrative features.
 */
export default cds.service.impl(function (this: Service) {
  // Short hand to the Returns entity for later use.
  const { Returns } = this.entities;

  /**
   * Ensure numeric price values before persisting books.
   * Converts a price sent as string to a number.
   */
  this.before(["CREATE", "UPDATE"], "Books", (
    req: Request<{ price?: number | string }>
  ) => {
    if (req.data.price !== undefined) {
      const value =
        typeof req.data.price === "string"
          ? parseFloat(req.data.price)
          : req.data.price;
      if (!Number.isNaN(value)) (req.data as any).price = value;
    }
  });

  /**
   * Custom action to contact a customer.
   * Simply logs the message and returns an acknowledgement.
   */
  this.on(
    "contact",
    "Customers",
    async (req: Request<{ subject: string; message: string }>) => {
      const { subject, message } = req.data;
      const { ID } = req.params[0] as { ID: string };
      console.log(`Contacting customer ${ID}: ${subject} - ${message}`);
      return "Message sent";
    }
  );

  /**
   * Custom action to request a return for an order item.
   * Creates a return entry and fetches it again for the response.
   */
  this.on(
    "requestReturn",
    "OrderItems",
    async (req: Request<{ reason: string }>) => {
      const { reason } = req.data;
      const { parent_ID, lineNo } = req.params[0] as {
        parent_ID: string;
        lineNo: number;
      };
      const inserted = await INSERT.into(Returns).entries({
        orderItem_parent_ID: parent_ID,
        orderItem_lineNo: lineNo,
        reason,
        status: "REQUESTED",
      });
      return SELECT.one.from(Returns).where({ ID: inserted.ID });
    }
  );
});
