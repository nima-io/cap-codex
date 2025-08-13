import cds, { Request, Service } from "@sap/cds";
const { INSERT, SELECT } = cds.ql;

/**
 * Service handlers for administrative features.
 */
export default cds.service.impl(function (this: Service) {
  // Short hand to the Returns entity for later use.
  const { Returns } = this.entities;
  const { Books, Authors } = this.entities;

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
      return cds.i18n.messages.at("contact.messageSent", req.user?.locale);
    }
  );

  /**
   * Automatically calculate netAmount and update related entities when creating order items.
   */
  this.before("CREATE", "OrderItems", async (req: Request) => {
    const { book_ID, quantity } = req.data as any;
    if (!book_ID || !quantity) return;

    const book = await SELECT.one
      .from(Books)
      .columns("price", "stock", "author_ID")
      .where({ ID: book_ID });
    if (!book) req.error(404, `Book ${book_ID} not found`);

    const price = Number(book.price);
    const net = price * quantity;
    (req.data as any).netAmount = net;

    await cds
      .update(Books)
      .set({ stock: { "-=": quantity } })
      .where({ ID: book_ID });

    if (book.author_ID) {
      const author = await SELECT.one
        .from(Authors)
        .columns("royaltyRate")
        .where({ ID: book.author_ID });
      if (author) {
        const royalty = (net * Number(author.royaltyRate)) / 100;
        await cds
          .update(Authors)
          .set({
            totalSales: { "+=": net },
            totalRoyalty: { "+=": royalty },
          })
          .where({ ID: book.author_ID });
      }
    }
  });

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
