sap.ui.define([
  "sap/ui/core/mvc/Controller",
], function (Controller) {
  "use strict";

  /**
   * Main controller handling navigation and saving of the book list.
   */
  return Controller.extend("admin.controller.Main", {
    /**
     * Persist any pending changes made in the table.
     */
    onSave: function () {
      this.getView().getModel().submitBatch("$auto");
    },

    /**
     * Navigate to the detail view of the selected book.
     *
     * @param {sap.ui.base.Event} oEvent the press event
     */
    onBookPress: function (oEvent) {
      const id = oEvent.getSource().getBindingContext().getProperty("ID");
      this.getOwnerComponent().getRouter().navTo("bookDetail", { ID: id });
    },

    /**
     * Navigate to the creation view for a new book.
     */
    onAddBook: function () {
      this.getOwnerComponent().getRouter().navTo("bookCreate");
    },
  });
});
