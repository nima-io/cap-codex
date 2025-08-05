sap.ui.define([
  "sap/ui/core/mvc/Controller"
], function(Controller) {
  "use strict";

  return Controller.extend("admin.controller.Main", {
    onSave: function() {
      this.getView().getModel().submitBatch("$auto");
    },

    onBookPress: function(oEvent) {
      const id = oEvent.getSource().getBindingContext().getProperty("ID");
      this.getOwnerComponent().getRouter().navTo("bookDetail", { ID: id });
    },

    onAddBook: function() {
      this.getOwnerComponent().getRouter().navTo("bookCreate");
    }
  });
});
